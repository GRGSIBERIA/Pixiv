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
					tags = param[:client].artist.tags(param[:userid])
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
			
			def TagDistanceFromCluster(source, dest, source_tag, param={})
				# あるタグ値以下は無視
				param[:skip_magnitude] ||= 0.0
				smag = source.magnitude(source_tag.count-1)
				if smag < param[:skip_magnitude] then return 1; end
				
				# あるタグ階層より小さい場合は無視
				param[:skip_tag_number] ||= 1
				if dest.max < param[:skip_tag_number] then return 1; end
				
				dtag = dest.tag_by_name[source_tag.name]
				if dtag == nil then return 1; end	# 見つからない場合は距離最大
				
				# 距離を求めているので短いほど類似度が高い
				distance = (smag - dest.magnitude(dtag.count-1)).abs
			end
			module_function :TagDistanceFromCluster
			
			# クラスター間の類似度を算出する
			# @param source [Util::Tag::Cluster] A
			# @param dest [Util::Tag::Cluster] B
			# @param param [Hash]
			# @param param [Float] :skip_magnitude この値以下のタグ値を無視する
			# @param param [Int] :skip_tag_number この値以下しかタグを持っていない人を無視する
			# @return [Float] タグ間の類似度、平均で出してる
			def ClusterSimilarity(source, dest, param={})
				tags_similarities = Array.new
				for slines in source.tags do
					for stag in slines do
						tags_similarities << TagDistanceFromCluster(source, dest, stag, param)
					end
				end
				
				# 小さいほど良かったので高いほど良いほうに直してる
				sum = 0.0
				tags_similarities.each{|s| sum += s}
				1.0 - (sum / tags_similarities.length)
			end
			module_function :ClusterSimilarity
		end
	end
end