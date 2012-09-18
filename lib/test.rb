require './pixiv.rb'

def showi(c, id)
	i = c.image.get(id)
	puts i.class
	puts i.uri
	puts i.title
	puts i.caption
	puts i.tags.each{|t| puts t.name}
	puts i.date.to_s
	
	puts i.thumbnail.uri
	puts i.medium.uri
	
	i.thumbnail.save("./")
	i.medium.save("./")
	puts "size:" + i.thumbnail.size.to_s
	
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

def showu(c, id)
	u = c.artist.get(id)
	puts u.userid
	puts u.name
	puts u.picture_count
	puts u.bookmark_count
	puts u.response_count
	
	puts u.detail.nickname
	puts u.detail.profile
	puts u.detail.personal_tags
	puts u.detail.sex
	puts u.detail.blood
	puts u.detail.address
	puts u.detail.age
	puts u.detail.birthday
	puts u.detail.job
	puts u.detail.homepage
	puts u.detail.twitter
	
	pics = c.artist.bookmarks(id)
	for i in 0..20 do
		pic = pics[i]
		if pic != nil then pic.large.save("./") end
		puts "bkm: " + pic.bookmark_count.to_s
	end
	
	#tags = c.artist.tags(id)
	#for tag in tags do
	#	puts tag.count.to_s + ":" + tag.name
	#end
end

c = Pixiv::Client.new

#showi(c, 30042252)	# イラスト
#showi(c, 29908791)
#showi(c, 28637532)	# 漫画
#show(c, 10)	# 存在しないイラスト

showu(c, 515127)
#showu(c, 44588)