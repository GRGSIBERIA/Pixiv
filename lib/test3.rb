require './pixiv.rb'

def WriteCluster(cluster)
	burn_text = "\xEF\xBB\xBF#{cluster.userid}\n"
	
	cnt = 0
	for line in cluster.tags do
		burn_text += "#{cnt+1}, #{cluster.magnitude(cnt)}, "
		for tag in line do
			burn_text += "#{tag.name}, "
		end
		burn_text += "\n"
		cnt += 1
	end
	
	File.write("./data/#{cluster.userid}.csv", burn_text.encode("UTF-8"))
end

client = Pixiv::Client.new
source_tag_cluster = Pixiv::Util::Tag.Clustering({:client => client, :userid => 515127})
WriteCluster(source_tag_cluster)

dest = nil
favorite_users_tag_cluster = Hash.new
favorite_list = client.artist.favorites(515127)
for user in favorite_list.items do
	# Hash<Int => Util::Tag::Cluster>
	fav_cluster = Pixiv::Util::Tag.Clustering({:client => client, :userid => user.userid})
	favorite_users_tag_cluster[user.userid] = fav_cluster
	WriteCluster(fav_cluster)
	puts fav_cluster.userid
	dest = fav_cluster
	break
end

puts Pixiv::Util::Tag.ClusterSimilarity(source_tag_cluster, dest)