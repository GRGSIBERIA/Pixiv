require './pixiv.rb'

def WriteCluster(cluster)
	burn_text = "#{cluster.userid}, #{cluster.nickname}\n"
	
	cnt = 0
	for line in cluster.tags do
		burn_text += "#{cnt+1}, #{cluster.magnitude(cnt)}, "
		for tag in line do
			burn_text += "#{tag.name}, "
		end
		burn_text += "\n"
		cnt += 1
	end
	
	File.write("./data/#{cluster.userid}.csv", burn_text.encode("Shift_JIS"))
end

client = Pixiv::Client.new
source_tag_cluster = Pixiv::Util::Tag.Clustering({:client => client, :userid => 515127})
WriteCluster(source_tag_cluster)

=begin
favorite_users_tag_cluster = Hash.new
favorite_users = client.artist.bookmarks(515127)
for user in favorite_users.list do
	# Hash<Int => Array<Presenter::Instance::Tag>>
	fav_tags = Pixiv::Util::Tag.Clustering({:client => client, :userid => user.userid})
	favorite_users_tag_cluster[user.userid] << fav_tags
end
=end
