=begin
ブックマークページから取得したサムネを入れておくためのクラス
=end

module Pixiv
	module Presenter
		module Author
			module Array
				class Bookmarks < Array::Base
					def initialize(agent, param)
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
end