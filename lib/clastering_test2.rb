=begin
Database::Clasteringのテスト用ファイル  
=end

require './pixiv/database/db.rb'
require './pixiv/database/tables/table_collection.rb'
require './pixiv/database/clastering/infer_probability.rb'

db = Pixiv::Database::DB.new
collection = Pixiv::Database::Tables::TableCollection.new(db.db)

guess = Pixiv::Database::Clastering::InferProbability.new(collection)
probs = guess.InferFromIllust(3007425)
result = probs.probability
 
tags = collection.table_base.GetMultiArray(
  "select tagid, name from tag_table", result.keys, ["i", "s"], "tagid", [:tagid, :name]
)
result.each do |k,v|
  puts k
  puts v
end

tags.each do |v|
  puts "#{v[:tagid]}, #{v[:name]}"
end

puts "-----------"

puts guess.Guess(probs)