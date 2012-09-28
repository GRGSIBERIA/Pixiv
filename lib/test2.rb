=begin
データマイニング用のテスト
=end

require './pixiv.rb'
require './pixiv/fun/stats/hot.rb'
require './pixiv/fun/math/fourier_transform.rb'

def start(client, id)
	tags = client.artist.tags(id)
	ctag = class_tag(client, tags)
	spec = spread(client, ctag)
	File.write("./spec.csv", spec.to_s.delete!('[]'))
	signal = inv(spec)
	File.write("./signal.csv", signal.to_s.delete!('[]'))
end

def class_tag(client, tags)
	tags.sort{|a,b| a.count <=> b.count}
	tags.each{|tag| puts "#{tag.count}:#{tag.name}"}
	
	class_of_tags = Array.new(tags[0].count)
	(0..class_of_tags.length-1).each{|i| class_of_tags[i] = [] }
	tags.each{|tag| class_of_tags[tag.count-1] << tag}
	class_of_tags
end

def spread(client, class_of_tags)
	tag_spectrum = Array.new
	for i in 0..class_of_tags.length-1 do
		tag_spectrum << Pixiv::Fun::Stats::Hot.TagsAverage(client, class_of_tags[i])
	end
	tag_spectrum	
end

def inv(tag_spectrum)
	Pixiv::Fun::Mathematics::FourierTransform.Inverse(tag_spectrum)
end

client = Pixiv::Client.new

start(client, 361607)
#start(client, 515127)