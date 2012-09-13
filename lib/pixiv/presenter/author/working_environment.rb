=begin
投稿者の作業環境
=end
require './pixiv/presenter/author/artist.rb'

module Pixiv
	module Presenter
		module Author
			class WorkingEnvironment < Artist
				# @param agent [Mechanize] セッションを確立したインスタンス
				def initialize(agent)
					super(agent)
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