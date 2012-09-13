=begin
投稿者のプロフィール
=end
require './pixiv/presenter/author/artist.rb'

module Pixiv
	module Presenter
		module Author
			class Profile < Artist
				# @param agent [Mechanize] セッションを確立したインスタンス
				def initialize(agent)
					super(agent)
				end
				
				# @return [String] 自己紹介
				def profile
				
				end
				
				# @return [Array<String>] パーソナルタグ
				def personal_tags
				
				end
				
				# @return [String] 性別
				# NOTE: 男性, 女性
				def sex
				
				end
				
				# @return [String] 血液型
				# NOTE: A型, B型, O型, AB型
				def blood
				
				end
				
				# @return [String] 住所
				# NOTE: 県名もしくは海外
				def address
				
				end
				
				# @return [Int] 年齢
				def age
				
				end
				
				# @return [Date] 誕生日
				def birthday
				
				end
				
				# @return [String] 職業
				def job
				
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
				
				# @return [String] ニックネーム
				def nickname
				
				end
			end
		end
	end
end