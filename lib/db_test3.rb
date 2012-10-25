require './pixiv/database/db.rb'

db = Pixiv::Database::DB.new
table = Pixiv::Database::Tables::IllustInfoTable.new(db.db)

st = Time.now
result = table.GetRecordFromIllustID(20)
et = Time.now
puts (et - st).to_s

puts result

#tagt = Pixiv::Database::Tables::TagTable.new(db.db)
#puts tagt.GetTagNames(result)

db.close