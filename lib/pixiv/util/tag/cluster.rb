=begin
タグの集合を扱いやすくするためのクラス
=end

module Pixiv
	module Util
		module Tag
			class Cluster
				# @param clustered_tags [Array<Array<Presenter::Instance::Tag>>] クラスター済みのタグ
				def initialize(clustered_tags, param={})
					@tags = clustered_tags
					if clustered_tags.length <= 0 then
						puts "0以上タグが付けられたユーザを指定してください"
						@tags = Array.new
						@max = 0
					else
						@max = @tags[0].count
					end
					param[:userid] ||= -1
					param[:nickname] ||= "no"
					@userid = param[:userid]
					@nickname = param[:nickname]
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
				
				# @return [Int] 一番大きい階層
				def max
					@max
				end
				
				# @return [Float] 一番大きな階層の逆数
				def difference
					@difference ||= 1.0 / max
				end
				private :difference
				
				# @return [Float] 長さ, 1に近づくほど良く付けられるタグ
				def magnitude(num)
					num * difference
				end
			end
		end
	end
end