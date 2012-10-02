=begin
ユーザ情報から集められたタグを格納する
=end

module Pixiv
	module Util
		module Tag
			class Cluster
				# @param userid [Int] ユーザID
				# @param param [Hash]
				# @param param [String] :nickname ニックネーム
				def initialize(client, userid, param={})
					clustered_tags ||= Array.new	# タグの存在しないユーザ
					param[:client] = client
					param[:nickname] ||= "no"
					@userid = userid
					@nickname = param[:nickname]
					
					@tags = Clustering(param)
					@tags ||= Array.new		# 作品を投稿していないユーザ対策
					PrepareTagsMaxCount()	# @maxの設定
					
					# タグ名ごとのタグ階層
					@names = Hash.new
					for line in tags do
						for tag in line do
							@names[tag.name] = tag
						end
					end
				end
				
				# 最も深いタグ階層を設定する
				def PrepareTagsMaxCount()
					if @tags.length <= 0 then
						puts "#{@userid}: 1つ以上タグが付けられたユーザを指定してください"
						@tags = Array.new
						@max = 0
					else
						@max = @tags[@tags.length-1][0].count
					end
				end
				private :PrepareTagsMaxCount
				
				# タグを階層ごとに配列にまとめる
				# :clientと:idもしくは:tagsのいずれかが必須
				# @param param [Hash]
				# @param param [Pixiv::Client] :client クライアント
				# @param param [Array<Presenter::Instance::Tag>] :tags まとめたいタグ配列
				# [Array<Array<Presenter::Instance::Tag>] 階層ごとにまとめたタグ配列
				def Clustering(param={})
					tags = param[:client].artist.tags(@userid)
					if tags == nil then return Array.new; end
					tags.sort{|a, b| a.count <=> b.count}
					cluster = ClusteringTags(tags, param)
				end
				private :Clustering
				
				# タグをまとめる, paramがないバージョン
				# @param tags [Array<Presenter::Instance::Tag>] まとめたいタグ配列
				# @return [Array<Array<Presenter::Instance::Tag>] 階層ごとにまとめたタグ配列
				def ClusteringTags(tags, param={})
					tag_cluster = nil
					if tags.length > 0 then
						tag_cluster = MakeTwoDimentionsTagsArray(tags)
					end
					tag_cluster
				end
				private :ClusteringTags
				
				# タグを二次元配列にまとめる
				# @param tags [Array<Presenter::Instance::Tag>] まとめたいタグ配列
				# @return [Array<Array<Presenter::Instance::Tag>] 階層ごとにまとめたタグ配列
				def MakeTwoDimentionsTagsArray(tags)
					max_count = 0		# タグのカウントの最大値を求める
					tags.each{|tag| max_count = tag.count > max_count ? tag.count : max_count}
					tag_cluster = Array.new(max_count)	# 二次元配列の生成
					for i in 0..tag_cluster.length-1 do tag_cluster[i] = Array.new; end
					tags.each{|tag| tag_cluster[tag.count-1] << tag}	# クラスター化したいタグを追加する
					tag_cluster
				end
				private :MakeTwoDimentionsTagsArray
				
				# @return [Int] タグを所有するユーザID, ない場合は-1
				def userid
					@userid
				end
				
				# @return [String] タグを所有するユーザの名前, ない場合は"no"
				def nickname
					@nickname
				end
				
				# @return [Array<Array<Presenter::Instance::Tag>>] クラスター済みのタグ
				def tags
					@tags
				end
				
				# @return [Hash<String => Presenter::Instance::Tag>] タグの名前からタグを割り出す
				def tag_by_name
					@names
				end
				
				# @return [Int] 一番大きい階層
				def max
					@max
				end
				
				# @return [Float] 一番大きな階層の逆数
				def difference
					@difference ||= 1.0 / max.to_f
				end
				
				# @return [Float] 長さ, 1に近づくほど良く付けられるタグ
				def magnitude(num)
					(num+1).to_f * difference
				end
			end
		end
	end
end