require './pixiv/database/db.rb'

db = Pixiv::Database::DB.new
table = Pixiv::Database::Tables::TagsArrayTable.new(db.db)

st = Time.now
result = table.GetIllustsFromTagIDArray([20, 21])
et = Time.now
puts (et - st).to_s

puts result

#tagt = Pixiv::Database::Tables::TagTable.new(db.db)
#puts tagt.GetTagNames(result)

db.close