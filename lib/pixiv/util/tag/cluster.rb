=begin
ユーザ情報から集められたタグを格納する
=end

module Pixiv
	module Util
		module Tag
			class Cluster
				# @param clustered_tags [Array<Array<Presenter::Instance::Tag>>] クラスター済みのタグ
				# @param param [Hash]
				# @param param [Int] :userid ユーザID
				# @param param [String] :nickname ニックネーム
				def initialize(clustered_tags, param={})
					clustered_tags ||= Array.new	# タグの存在しないユーザ
					@tags = clustered_tags
					
					if clustered_tags.length <= 0 then
						puts "#{param[:userid]}: 0以上タグが付けられたユーザを指定してください"
						@tags = Array.new
						@max = 0
					else
						@max = @tags[@tags.length-1][0].count
					end
					param[:userid] ||= -1
					param[:nickname] ||= "no"
					@userid = param[:userid]
					@nickname = param[:nickname]
					
					# タグ名ごとのタグ階層
					@names = Hash.new
					for line in tags do
						for tag in line do
							@names[tag.name] = tag
						end
					end
				end
				
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