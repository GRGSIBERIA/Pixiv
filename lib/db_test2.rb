=begin
タグなどの整理を行うためのコード  
=end
require './pixiv/database/db.rb'

def MargeIllustTables(db)
  usercount = 0
  db.db.execute('select max(userid) from illust_info_table;') do |rows|
    usercount = rows[0].to_i
  end
  
  db.db.execute('attach "dest.db" as dest;')
  db.db.execute('insert into illust_info_table select * from dest.illust_info_table where dest.userid > ' + usercount + ';')
  db.db.execute('insert or ignore into tags_array_buffer_table select * from dest.tags_array_buffer_table;')
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

def DuplicateCheck(db)
  datas = Array.new
  sql = 'select distinct * from tags_array_buffer_table'
  db.db.execute(sql) do |rows|
    datas << [rows[0].to_i, rows[1]]
  end
  
  db.db.execute('delete from tags_array_buffer_table')
  
  sql = 'insert or ignore into tags_array_buffer_table values (?, ?)'
  db.db.transaction
  for item in datas do
    db.db.execute(sql, item)
  end
  db.db.commit
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
  end
  db.db.commit
end

def ArrangeTagsArrayTable(db)
  tag_hash = Hash.new
  db.db.execute('select tagid, name from tag_table;') do |rows|
    tag_hash[rows[1]] = rows[0].to_i
  end
  buffer_hash = Hash.new
  db.db.execute('select illust_id, tagname from tags_array_buffer_table;') do |rows|
    buffer_hash[rows[1]] ||= Array.new
    buffer_hash[rows[1]] << rows[0].to_i
  end
  
  exec = Array.new
  sql = 'insert into tags_array_table values (?, ?);'
  buffer_hash.each {|name, illusts|
    for illust in illusts do
      exec << [sql, [illust, tag_hash[name].to_i]]
    end
  }
  
  db.db.transaction
  for e in exec do
    db.db.execute(e[0], e[1])
  end
  db.db.commit
end

db = Pixiv::Database::DB.new
ArrangeTagTables(db)
ArrangeTagsArrayTable(db)
#DuplicateCheck(db)

db.close