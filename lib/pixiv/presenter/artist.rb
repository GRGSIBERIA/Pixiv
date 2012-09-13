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
			
			# @return [String] ホームページアドレス
			def homepage
			
			end
			
			# @return [String] Twitterアカウント名
			def twitter
			
			end
			
			# @return [String] TwitterアカウントへのURI
			def twitter_uri
			
			end
			
			# @return [Int] 投稿したイラスト数
			def picture_count
				
			end
			
			# @return [String] ニックネーム
			def nickname
			
			end
		end
	end
end