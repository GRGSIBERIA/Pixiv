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
  for id in SetupRange(db, 1000) do
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
  first_id = 10
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
          puts sql
          # タグをなんとかする
          EntryTags(db, info.tags, illust_id)
        end
        if row[0] > 12 then break end
        db.db.execute("update crawled_id_table set userid = #{userid} where crawl_type = 'illust_by_user'")  # 最後に記録したIDをここで
      rescue Pixiv::IllustNotFoundError
        puts "notfound:#{row[0]}"
      end
    end
  end
end

# イラストごとにタグの登録
def EntryTags(db, tags, illust_id)
  tagid = 0
  cnt = 0 # 付けられたタグのカウント
  maxid = 10
  db.db.execute("select max(tagid), name from tag_table;") do |row|
    maxid = row[0].to_i   # タグIDの最大値を取得
  end
  
  # タグの数だけ走らせる
  for tag in tags do
    existflag = false
    tagname = tag.name.gsub(/['"]/) {|ch| ch + ch}
    tagname = tagname.toutf8
    begin
      sql = "select tagid, count from tag_table where name = '#{tagname}';".toutf8
      db.db.execute(sql) do |e|
        existflag = true        # 既に使用されているタグがあった
        tagid = e[0].to_i  # ここでIDが変更される
        cnt = e[1].to_i + 1
      end
    rescue SQLite3::SQLException
      # テーブルがない場合は怒られるので止める
    end
    sql = ""
    if !existflag then
      maxid += 1
      sql = "insert into tag_table values (#{maxid}, '#{tagname}', 1);".toutf8  # タグの追加
      tagid = maxid
    else
      sql = "update tag_table set count = #{cnt} where tagid = #{tagid}".toutf8 # 見つかった場合はカウントを増やすだけ
    end
    db.execute(sql)
    puts "tag_tb:" + sql
    sql = "insert into illust_tags_array_table values (#{illust_id}, #{tagid});".toutf8
    db.execute(sql) # イラストごとのタグの追加
    puts "arr_tb:" + sql
    tagid = maxid
  end
end

db = Pixiv::Database::DB.new
client = Pixiv::Client.new

#db.drop    # 全て削除
#db.clear  # 消してるので注意

start_time = Time.now

CrawlUserInfo(client, db)
#CrawlIllustByUser(client, db)

end_time = Time.now
puts "time:" + (end_time - start_time).to_s + "s"
puts Time.now.to_s

db.close
