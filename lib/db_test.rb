require 'kconv'
require 'cgi'
require './pixiv.rb'
require './pixiv/database/db.rb'

# 範囲の指定
def SetupRange(db, span)
  start = 10
  db.db.execute("select max(userid) from user_info_table") do |row|
    start = row[0].to_i
  end
  if start < 10 then start = 9 end
  start+1..start+span+1
end

# UserInfoTableにデータを突っ込む
def CrawlUserInfo(client, db)
  puts "crawl user----"
  for id in SetupRange(db, 100) do
    begin
      info = client.artist.info(id)
      puts id
      deta = info.detail
      nickname = deta.nickname.gsub(/['"]/) {|ch| ch + ch}
      location = info.location
      sql = "insert into user_info_table values (#{id}, '#{nickname}', '#{location}');"
      db.execute(sql)
    rescue Pixiv::ArtistNotFoundError
      puts "notfound:#{id}"
    end
  end
end

# UserInfoTableベースでイラストを取得する
def CrawlIllustByUser(client, db)
  db.db.execute("select userid, location from user_info_table") do |row|
    if row[1] != "" then  # locationが空の場合、イラストを投稿していない
        items = client.artist.pictures(row[0]).items
        begin
          for item in items do
            info = client.image.info(item.illust_id)
            illust_id = info.illust_id
            userid = row[0]
            score = info.score_count
            view = info.view_count
            rated = info.rated_count
            title = info.title.gsub(/['"]/) {|ch| ch + ch}
            date = info.date
            if info.class == Pixiv::Presenter::Image::Illust then
              size = "#{info.width},#{info.height}"
              illust_type = "i"
            else
              size = "#{info.page_count}p"
              illust_type = "m"
            end
            r18 = info.r18 ? "t" : "f"
            
            sql = "insert into illust_info_table values (#{illust_id}, #{row[0]}, #{score}, #{view}, #{rated}, '#{title}', '#{date}', '#{illust_type}', '#{r18}', '#{size}');"
            #db.execute(spl)
            
            # タグをなんとかする
          end
          if row[0] > 20 then break end
        rescue Pixiv::IllustNotFoundError
          puts "notfound:#{row[0]}"
        end
    end
  end
end

# タグの登録
def EntryTags(db, tags, illust_id)
  id = 0
  cnt = 0 # 付けられたタグのカウント
  db.db.execute('select tagid, count from tag_table where max(tagid) = tagid;') do |e|
    id = e[0].to_i + 1
    cnt = e[1].to_i + 1
  end
  
  # タグの数だけ走らせる
  for tag in tags do
    flag = false
    db.db.execute("select tagid from tag_table wehere name = #{tag.name};") do |e|
      flag = true
    end
    if !flag then # 見つからない場合だけ追加する
      db.execute("insert into tag_table values (#{id}, #{tag.name}, #{cnt});")  # タグの追加
    end
    db.execute("insert into illust_tags_array_table values (#{illust_id}, #{id});") # イラストごとのタグの追加
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

db.close
