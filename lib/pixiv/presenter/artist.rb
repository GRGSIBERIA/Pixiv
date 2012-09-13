=begin
Pixivのユーザ情報を格納する
=end
require './pixiv/presenter/base.rb'

module Pixiv
	module Presenter
		class Author < Base
			# @return [String] ユーザ名
			def name
			
			end
			
			# @return [String] ホームページ
			def homepage
			
			end
			
			# @return [String] Twitterアカウント名
			def twitter
			
			end
			
			# @return [Int] 投稿したイラスト数
			def illust_count
				
			end
		end
	end
end