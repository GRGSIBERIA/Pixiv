require './pixiv.rb'

def showi(c, id)
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

def showu(c, id)
	u = c.artist.get(id)
	puts u.userid
	puts u.name
	puts u.picture_count
	puts u.bookmark_count
	puts u.response_count
	
	puts u.profile.nickname
	puts u.profile.profile
	puts u.profile.personal_tags
	puts u.profile.sex
	puts u.profile.blood
	puts u.profile.address
	puts u.profile.age
	puts u.profile.birthday
	puts u.profile.job
	puts u.profile.homepage
	puts u.profile.twitter
	puts u.profile.twitter_uri
end

c = Pixiv::Client.new

=begin
showi(c, 30042252)	# イラスト
showi(c, 29908791)
showi(c, 28637532)	# 漫画
#show(c, 10)	# 存在しないイラスト
=end

showu(c, 515127)
showu(c, 44588)