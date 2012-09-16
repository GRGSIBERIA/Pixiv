=begin
ユーザが投稿したサムネ用の画像をまとめたもの
=end
require './pixiv/presenter/author/array/base.rb'

module Pixiv
	module Presenter
		module Author
			module Array
				class Pictures
					# 投稿されたイラストを取得する
					# @param userid [Int] ユーザID
					# @param param [Hash]
					# @param param [Range] :range 表示させたいページ範囲
					def initialize(param={})
						super(param)
					end
				end
			end
		end
	end
end