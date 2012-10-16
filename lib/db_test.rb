require 'kconv'
require 'cgi'
require './pixiv.rb'
require './pixiv/database/db.rb'

# 範囲の指定
def SetupRange(db, span)
  start = 9
  db.db.execute("select max(userid) from user_info_table") do |row|
    start = row[0].to_i
  end
  if start < 10 then start = 9 end
  start+1..start+span+1
end

# UserInfoTableにデータを突っ込む
def CrawlUserInfo(client, db)
  puts "crawl user----"
  exec_array = Array.new
  for id in SetupRange(db, 5000) do
    begin
      info = client.artist.info(id)
      puts id
      nickname = info.name
      location = info.location
      sql = "insert into user_info_table values (?, ?, ?);"
      exec_array << [sql, [id, nickname, location]]
    rescue Pixiv::ArtistNotFoundError
      puts "notfound:#{id}"
    end
  end
  
  # まとめてtransaction
  db.db.transaction
  for exec in exec_array do
    db.db.execute(exec[0], exec[1])
  end
  db.db.commit
end

# UserInfoTableベースでイラストを取得する
def CrawlIllustByUser(client, db)
  puts "crawl illust----------------"
  first_id = 9
  max_count = 1000 # N人分取得する
  count = 0
  last_userid = 0
  exec_array = Array.new
  db.db.execute("select userid from crawled_id_table") do |row|
    first_id = row[0].to_i  # 最後に調べたユーザIDを初期値にセット
  end
  db.db.execute("select userid, location from user_info_table where userid > #{first_id}") do |row|
    if row[1] != "" then  # locationが空の場合、イラストを投稿していない
      userid = row[0]
      items = client.artist.pictures(userid).items
      begin
        for item in items do
          info = client.image.info(item.illust_id)
          illust_id = info.illust_id
          score = info.score_count
          view = info.view_count
          rated = info.rated_count
          title = info.title
          date = info.date
          if info.class == Pixiv::Presenter::Image::Illust then
            illust_type = "i"
          else
            illust_type = "m"
          end
          r18 = info.r18 ? "t" : "f"
          
          puts "#{row[0]} => #{illust_id}"
          cols = [illust_id, row[0], score, view, rated, title, date.to_s, illust_type, r18]
          sql = "insert into illust_info_table values (?, ?, ?, ?, ?, ?, ?, ?, ?);"
          exec_array << [sql, cols] # トランザクションさせたい
          last_userid = row[0]
          
          # タグをなんとかする
          EntryTags(db, exec_array, info.tags, illust_id)
        end
        if max_count <= count then break end
        count += 1
        #db.db.execute("update crawled_id_table set userid = #{userid} where crawl_type = 'illust_by_user'")  # 最後に記録したIDをここで
      rescue Pixiv::IllustNotFoundError
        puts "notfound:#{row[0]}"
      end
    end
  end
  
  # トランザクション用に退避
  db.db.transaction
  for exec in exec_array do
    db.db.execute(exec[0], exec[1])
  end 
  db.db.commit
  db.db.execute("update crawled_id_table set userid = #{last_userid} where crawl_type = 'illust_by_user'")  # 最後に記録したIDをここで
end

# イラストごとにタグの登録
def EntryTags(db, exec_array, tags, illust_id)
  for tag in tags do
    # タグ名で強引に登録、後で集計するつもりで
    sql = "insert into tags_array_buffer_table values (?, ?)"
    exec_array << [sql, [illust_id, tag.name]]
  end
end

db = Pixiv::Database::DB.new
client = Pixiv::Client.new

#db.drop    # 全て削除
#db.clear  # 消してるので注意

start_time = Time.now

#CrawlUserInfo(client, db)
CrawlIllustByUser(client, db)

end_time = Time.now
puts "time:" + (end_time - start_time).to_s + "s"
puts Time.now.to_s

db.close
