=begin
投稿者のプロフィール
=end
require './pixiv/presenter/author/artist.rb'

module Pixiv
	module Presenter
		module Author
			class Detail < Base
				# @param agent [Mechanize] セッションを確立したインスタンス
				def initialize(agent)
					super(agent)
					@hash = Parser::Author.get_profile_hash(@page)
				end
				
				# ハッシュを取得するけどない場合はnilを返すだけ。例外に対応。
				def GetHash(name)
					begin
						@hash[name]
					rescue
						nil
					end
				end
				private :GetHash
				
				# @return [String] ニックネーム
				def nickname
					@nickname ||= GetHash("ニックネーム")
				end
				
				# @return [String] 自己紹介
				def profile
					@profile ||= GetHash("自己紹介")
				end
				
				# @return [Array<String>] パーソナルタグ
				def personal_tags
					begin
						@personal_tags ||= @hash["パーソナルタグ"].split(' ')
					rescue
						nil
					end
				end
				
				# @return [String] 性別
				# NOTE: 男性, 女性
				def sex
					@sex ||= GetHash("性別")
				end
				
				# @return [String] 血液型
				# NOTE: A型, B型, O型, AB型
				def blood
					@blood ||= GetHash("血液型")
				end
				
				# @return [String] 住所
				# NOTE: 県名もしくは海外
				def address
					@address ||= GetHash("住所")
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
					@job ||= GetHash("職業")
				end
				
				# @return [String] ホームページアドレス
				def homepage
					@homepage ||= GetHash("HPアドレス")
				end
				
				# @return [String] Twitterアカウント名
				def twitter
					@twitter ||= GetHash("Twitter")
				end
				
				# @return [String] Skypeアカウント名
				def skype
					@skype ||= GetHash("Skype")
				end
				
				# @return [String] コンピュータ
				def computer
				
				end
				
				# @return [String] モニター
				def monitor
				
				end
				
				# @return [String] ソフト
				def software
				
				end
				
				# @return [String] スキャナー
				def scaner
				
				end
				
				# @return [String] タブレット
				def tablet
				
				end
				
				# @return [String] マウス
				def mouse
				
				end
				
				# @return [String] プリンター
				def printer
				
				end
				
				# @return [String] デスクトップの上にあるもの
				def on_the_desk
				
				end
				
				# @return [String] 好きな音楽
				def like_music
				
				end
				
				# @return [String] 椅子
				def chair
				
				end
				
				# @return [String] その他
				def other
				
				end
			end
		end
	end
end