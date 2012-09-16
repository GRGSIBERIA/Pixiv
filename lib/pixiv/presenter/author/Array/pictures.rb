=begin
ユーザが投稿したサムネ用の画像をまとめたもの
=end

module Pixiv
	module Presenter
		module Author
			module Array
				class Pictures
					# 投稿されたイラストを取得する
					# @param userid [Int] ユーザID
					# @param param [Hash]
					# @param param [Range] :range 表示させたいページ範囲
					def initialize(userid, param={})
						super(userid, param)
					end
				end
			end
		end
	end
end