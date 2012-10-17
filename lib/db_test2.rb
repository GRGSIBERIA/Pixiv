=begin
タグなどの整理を行うためのコード  
=end
require './pixiv/database/db.rb'

def MargeIllustTables(db)
  usercount = 0
  db.db.execute('select max(userid) from illust_info_table;') do |rows|
    usercount = rows[0].to_i
  end
  illust_id = 0
  db.db.execute('select max(tagid) from tags_array_buffer_table;') do |rows|
    illust_id = rows[0].to_i
  end
  
  db.db.execute('attach "dest.db" as dest;')
  db.db.execute('insert into illust_info_table select * from dest.illust_info_table where dest.userid > ' + usercount + ';')
  #db.db.execute('insert into tags_array_buffer_table select * from dest.tags_array_buffer_table where dest.illust_id > ' + illust_id + ';')
  db.db.execute('detach dest;')
end

def MargeUserTable(db)
  usercount = 0
  db.db.execute('select max(userid) from user_info_table;') do |rows|
    usercount = rows[0].to_i
  end
  db.db.execute('attach "dest.db" as dest;')
  db.db.execute('insert into user_info_table select * from dest.user_info_table where dest.userid > ' + usercount + ';')
  db.db.execute('detach dest;')
end

# バッファのものをなんとかする
def ArrangeTagTables(db)
  id = 1
  arranged_hash = Hash.new
  db.db.execute('select * from tags_array_buffer_table;') do |rows|
    if !arranged_hash.key?(rows[1]) then
      arranged_hash[rows[1]] = {:id => id, :count => 1, :illust_id => rows[0].to_i}
      id += 1
    else
      arranged_hash[rows[1]][:count] += 1
    end
  end
  
  db.db.transaction
  arranged_hash.each do |k,v|
    db.db.execute('insert into tag_table values (?, ?, ?);', [v[:id], k, v[:count]])
    db.db.execute('insert into tags_array_table values (?, ?)', [v[:illust_id], v[:id]])
  end
  db.db.commit
end

db = Pixiv::Database::DB.new
ArrangeTagTables(db)
db.close