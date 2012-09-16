=begin
ユーザが投稿したサムネ用の画像をまとめたもの
=end
require './pixiv/presenter/author/array/base.rb'

module Pixiv
	module Presenter
		module Author
			module Array
				class Pictures < Array::Base
					# 投稿されたイラストを取得する
					# @param userid [Int] ユーザID
					# @param param [Hash]
					# @param param [Range] :range 表示させたいページ範囲
					def initialize(agent, param={})
						super(agent, param)
					end
				end
			end
		end
	end
end