=begin
Pixivのイラスト情報をまとめておくためのクラス
=end
require './pixiv/presenter/base.rb'

module Pixiv
	module Presenter < Base
		# イラスト情報を格納するためのクラス
		class Illust
			# @return [Array<String>] タグ情報の配列
			def tags
			
			end
			
			# @return [String] タイトル
			def title
			
			end

			# @return [String] キャプション
			def caption
			
			end
			
			# @return [Presenter::Author] ユーザ情報
			def author
			
			end
			
			# @return [Date] 投稿した日付
			def date
			
			end
			
			# @return [String] イラストの大きさ
			def size
			
			end
		end
	end
end