=begin
Pixivのユーザ情報を格納する
=end
require './pixiv/presenter/base.rb'
require './pixiv/parser/author.rb'

module Pixiv
	module Presenter
		module Author
			class Artist < Base
				# @param agent [Mechanize] セッションを確立したインスタンス
				def initialize(agent)
					super(agent)
				end
			
				# @return [String] ユーザ名
				def name
				
				end
				
				# @return [Presenter::Author::Profile] プロフィール
				def profile
				
				end
				
				# @return [Presenter::Author::WorkingEnvironment] 作業環境
				def working_environment
				
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
				
				# @return [Int] 投稿したイラスト数
				def picture_count
					
				end
			end
		end
	end
end