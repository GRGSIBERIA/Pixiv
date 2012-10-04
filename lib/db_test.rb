require 'sqlite3'

db = SQLite3::Database.new('test.db')

begin
  cnt = 0
  sql = << EOS
    abs
  EOS
  db.execute('select count(*) from sqlite_master where type="table" and name="hoge_table";') do |row|
    cnt = row.join("\t")
  end
  puts cnt
rescue SQLite3::SQLException
  puts "no such test_table"
  
end

db.close
