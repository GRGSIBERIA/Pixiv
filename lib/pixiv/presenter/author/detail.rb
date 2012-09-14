=begin
投稿者のプロフィール
=end
require './pixiv/presenter/author/artist.rb'

module Pixiv
	module Presenter
		module Author
			class Profile < Base
				# @param agent [Mechanize] セッションを確立したインスタンス
				def initialize(agent)
					super(agent)
					@hash = Parser::Author.get_profile_hash(@page)
					puts @hash.class
				end
				
				# @return [String] ニックネーム
				def nickname
					begin
						@nickname ||= @hash["ニックネーム"]
					rescue
						nil
					end
				end
				
				# @return [String] 自己紹介
				def profile
					begin
						@profile ||= @hash["自己紹介"]
					rescue
						nil
					end
				end
				
				# @return [Array<String>] パーソナルタグ
				def personal_tags
					begin
						@personal_tags ||= @hash["パーソナルタグ"].split(' ')
					rescue NoMethodError
						nil
					end
				end
				
				# @return [String] 性別
				# NOTE: 男性, 女性
				def sex
					begin
						@sex ||= @hash["性別"]
					rescue
						nil
					end
				end
				
				# @return [String] 血液型
				# NOTE: A型, B型, O型, AB型
				def blood
					begin
						@blood ||= @hash["血液型"]
					rescue
						nil
					end
				end
				
				# @return [String] 住所
				# NOTE: 県名もしくは海外
				def address
					begin
						@address ||= @hash["住所"]
					rescue
						nil
					end
				end
				
				# @return [Int] 年齢
				def age
					begin
						@age ||= @hash["年齢"].delete("歳").to_i
					rescue
						nil
					end
				end
				
				# @return [Date] 誕生日
				def birthday
					begin
						@birthday ||= Date.strptime((Time.now.year-@age).to_s + "年" + @hash["誕生日"], "%Y年%m月%d日")
					rescue
						nil
					end
				end
				
				# @return [String] 職業
				def job
					begin
						@job ||= @hash["職業"]
					rescue
						nil
					end
				end
				
				# @return [String] ホームページアドレス
				def homepage
					begin
						@homepage ||= @hash["HPアドレス"]
					rescue
						nil
					end
				end
				
				# @return [String] Twitterアカウント名
				def twitter
					begin
						@twitter ||= @hash["Twitter"]
					rescue
						nil
					end
				end
				
				# @return [String] Skypeアカウント名
				def skype
					begin
						@skype ||= @hash["Skype"]
					rescue
						nil
					end
				end
			end
		end
	end
end