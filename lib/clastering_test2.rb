=begin
Database::Clasteringのテスト用ファイル  
=end

require './pixiv/database/db.rb'
require './pixiv/database/tables/table_collection.rb'
require './pixiv/database/clastering/guess_tag_type.rb'

db = Pixiv::Database::DB.new
collection = Pixiv::Database::Tables::TableCollection.new(db.db)

guess = Pixiv::Database::Clastering::GuessTagType.new(collection)
result = guess.GuessType(9223362)

tags = result.keys

puts result
puts collection.tag_table.GetTagNamesFromTagIDArray(tags)