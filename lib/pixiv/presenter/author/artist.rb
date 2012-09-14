=begin
Pixivのユーザ情報を格納する
=end
require './pixiv/presenter/base.rb'
require './pixiv/presenter/author/detail.rb'
require './pixiv/parser/author.rb'

module Pixiv
	module Presenter
		module Author
			class Artist < Base
				# @param agent [Mechanize] セッションを確立したインスタンス
				# @param userid [Int] ユーザID
				def initialize(agent, userid)
					super(agent)
					@userid = userid
				end
			
				# @return [String] ユーザ名
				def name
					@name ||= Parser::Author.name(@page)
				end
				
				# @return [Int] ユーザID
				def userid
					@userid
				end
				
				# @return [Int] 投稿したイラスト数
				def picture_count
					@picture_count ||= Parser::Author.picture_count(@page)
				end
				
				# @return [Int] ブクマ数
				def bookmark_count
					@bookmark_count ||= Parser::Author.bookmark_count(@page)
				end
				
				# @return [Int] イメージレスポンス数
				def response_count
					@response_count ||= Parser::Author.response_count(@page)
				end
				
				# @return [Presenter::Author::Profile] プロフィール
				def detail
					@detail ||= Presenter::Author::Detail.new(@agent)
				end
				
				# @return [String] 背景色
				# EXAMPLE: RRGGBB
				def background_color
					# 取得する方法がわからんので無効
				end
				
				# @return [Presenter::Instance::Picture] 背景画像
				def background_image
					# 取得する方法がわからんので無効
				end
				
				# @return [String] 並べ方
				# EXAMPLE: xy, x, y, no???
				def arrangement
					# 取得する方法がわからんので無効
				end
			end
		end
	end
end