require './pixiv.rb'

def show(c, id)
	i = c.image.show(id)
	puts i.class
	puts i.uri
	puts i.title
	puts i.caption
	puts i.tags
	puts i.date.to_s
	if i.class == Pixiv::Presenter::Illust
		puts i.size
	end
	puts i.tools
	puts i.view_count
	puts i.rated_count
	puts i.score_count
	puts i.location
	puts i.extension
	
	puts i.thumbnail_uri
	puts i.medium_uri
	
	if i.class == Pixiv::Presenter::Manga
		puts i.page_count
		puts i.large_uris
		puts i.big_uris
	end
	
	puts "------------"
	i
end

c = Pixiv::Client.new
show(c, 30042252)
show(c, 29908791)
test = show(c, 28637532)

File.binwrite("./" + test.large_filename(1), test.large(1))