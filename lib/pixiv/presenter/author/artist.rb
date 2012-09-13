=begin
Pixivのユーザ情報を格納する
=end
require './pixiv/presenter/base.rb'

module Pixiv
	module Presenter
		module Author
			class Artist < Base
				# @return [String] ユーザ名
				def name
				
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
				
				# @return [String] 背景色
				# EXAMPLE: RRGGBB
				def background_color
				
				end
				
				# @return [Presenter::Instance::Picture] 背景画像
				def background_image
				
				end
				
				# @return [String] 並べ方
				# EXAMPLE: xy, x, y, no???
				def arrangement
				
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
				
				# @return [Int] 投稿したイラスト数
				def picture_count
					
				end
				
				# @return [String] ニックネーム
				def nickname
				
				end
			end
		end
	end
end