#! ruby -Ku
=begin
Database::Clasteringのテスト用ファイル  
=end

require './pixiv/database/db.rb'
require './pixiv/database/tables/table_collection.rb'
require './pixiv/database/clastering/infer_probability.rb'

db = Pixiv::Database::DB.new
collection = Pixiv::Database::Tables::TableCollection.new(db.db)
guess = Pixiv::Database::Clastering::InferProbability.new(collection)

target_name = '魔法少女まどか☆マギカ'
count = collection.tags_array_table.GetCountFromTagName(target_name)
id = collection.tag_table.GetTagIDFromTagName(target_name)
array = collection.tags_array_table.GetIllustsFromTagID(id)

success = 0
miss = 0
miss_list = Array.new

#--------------------
# TODO: 確率テーブルに初期値を与える
# ?にはtag_tableのタグIDを突っ込む
# insert into tags_probability_table values (?, -1.0, -1.0, -1.0);

for illust in array do
  probs = guess.InferFromIllust(illust)
  result = guess.InferWorks(probs)
  
  name = collection.tag_table.GetTagNameFromTagID(result[:tagid])
  if name == target_name then
    success += 1
    puts "c:#{count}, s:#{success}"
  else
    miss += 1
    puts "c:#{count}, m:#{miss}"
    miss_list << {:tagid => result[:tagid], :illust => illust, :name => name}
    puts name, illust
  end
  count -= 1
  #puts "-----------"
end

str = "c,#{success+miss}, s,#{success}, m,#{miss}\n"
puts str

miss_list.each do |e|
  str += "#{e[:tagid]}, #{e[:name]}, #{e[:illust]}\n"
end
File.write("miss_list.csv", str)
