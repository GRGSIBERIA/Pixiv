=begin
タグ関連の便利メソッド集
=end
require './pixiv/presenter/instance/tag.rb'
require './pixiv/util/tag/cluster.rb'

module Pixiv
	module Util
		module Tag
			# タグを階層ごとに配列にまとめる
			# :clientと:idもしくは:tagsのいずれかが必須
			# @param param [Hash]
			# @param param [Pixiv::Client] :client クライアント
			# @param param [Int] :userid 取得したいID
			# @param param [Array<Presenter::Instance::Tag>] :tags まとめたいタグ配列
			# @return [Util::Tag::Cluster] 階層ごとにまとめられたタグ
			def Clustering(param={})
				cluster = nil
				if param[:tags] != nil then
					cluster = Util::Tag.ClusteringTags(param[:tags], param)
				else
					tags = param[:client].artist.tags(param[:id])
					tags.sort{|a, b| a.count <=> b.count}
					cluster = Util::Tag.ClusteringTags(tags, param)
				end
				cluster
			end
			module_function :Clustering
			
			# タグをまとめる, paramがないバージョン
			# @param tags [Array<Presenter::Instance::Tag>] まとめたいタグ配列
			# @return [Util::Tag::Cluster] 階層ごとにまとめられたタグ
			def ClusteringTags(tags, param={})
				tag_cluster = nil
				if tags.length > 0 then
					tag_cluster = Array.new(tags[0].count)
					for i in 0..tag_cluster.length-1 do tag_cluster[i] = Array.new; end
					tags.each{|tag| tag_cluster[tag.count-1] << tag}
				end
				Util::Tag::Cluster.new(tag_cluster, param)
			end
			module_function :ClusteringTags
		end
	end
end