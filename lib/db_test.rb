require './pixiv.rb'
require './pixiv/database/db.rb'

db = Pixiv::Database::DB.new
#client = Pixiv::Client.new

#db.clear  # 消してるので注意

for id in 10..100 do
  begin
    info = client.artist.info(id)
    puts id
    deta = info.detail
    name = info.name.encode("utf-8")
    nickname = deta.nickname.encode("utf-8")
    profile = deta.profile.encode("utf-8")
    location = info.location.encode("utf-8")
    sql = "insert into user_info_table values (#{id}, '#{nickname}', '#{profile}', '#{location}')"
    db.execute(sql)
  rescue Pixiv::ArtistNotFoundError
    puts "notfound:#{id}"
  end
end

db.close