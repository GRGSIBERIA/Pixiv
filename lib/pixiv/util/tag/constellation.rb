=begin
タグを収集するための集団クラス
タグを追加するとタグごとの合計値を求めてくれる
=end

module Pixiv
	module Util
		module Tag
			class Constellation
				def initialize()
					@tags = Hash.new
					@counter = 0
				end
				
				# @return [Hash<Presenter::Instance::Tag => Int>] タグ名からタグ数を引き出す
				def tags
					@tags
				end
				
				# @return [Int] 全部で入れられたタグの総数
				def count
					@counter
				end
				
				# @param tag [Presenter::Instance::Tag] タグ
				# @return Addが呼ばれた回数
				def Add(tag)
					@tags[tag] ||= 0
					@tags[tag] += 1
					@counter += 1
				end
			end
		end
	end
end