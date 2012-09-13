require './pixiv.rb'

def show(c, id)
	i = c.image.get(id)
	puts i.class
	puts i.uri
	puts i.title
	puts i.caption
	puts i.tags
	puts i.date.to_s
	
	puts i.thumbnail.uri
	puts i.medium.uri
	
	i.thumbnail.save("./")
	i.medium.save("./")
	
	case i.type
	when "illust"
		puts i.large.uri
	when "manga"
		for page in i.larges do
			puts page.uri
		end
	end
	
	
	puts "------------"
	i
end

c = Pixiv::Client.new
show(c, 30042252)
show(c, 29908791)
show(c, 28637532)
#show(c, 10)	# ‘¶İ‚µ‚È‚¢ƒCƒ‰ƒXƒg

#File.binwrite("./" + test.large_filename(1), test.large(1))