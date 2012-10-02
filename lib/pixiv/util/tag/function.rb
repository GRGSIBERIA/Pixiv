=begin
タグ関連の便利メソッド集
=end
require './pixiv/presenter/instance/tag.rb'
require './pixiv/util/tag/cluster.rb'

module Pixiv
	module Util
		module Tag
			# クラスターから頑張ってタグ間の類似度を取る
			# 類似度の尺度はA x Bなので互いに高ランクほど強調される
			# @param source []
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
				#distance = smag - dest.magnitude(dtag.count-1)
				#distance *= distance
				# 互いに良いスコアだと伸びるけど、片方が落ちると伸びない
				# 31 x 41 = 1,271
				# 20 x 20 = 400
				# 200 x 1  = 200
				source_tag.count * dtag.count
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
				
				# タグ同士の倍数を取った平均値を利用してる
				sum = 0.0
				tags_similarities.each{|s| sum += s}
				(sum / tags_similarities.length)
			end
			module_function :ClusterSimilarity
		end
	end
end