=begin
特定のユーザ情報を問い合わせるためのクラス
=end
require './pixiv/api/base.rb'
require './pixiv/presenter/image/thumbnail.rb'

require './pixiv/presenter/author/array/pictures.rb'

module Pixiv
	module API
		class Artist < Base
			# @param agent [Mechanize] セッションの確立している状態のもの
			def initialize(agent)
				super(agent)
			end
			
			# ユーザ情報の取得を行う
			# @param userid [Int] ユーザID
			def get(userid)
				uri = "http://www.pixiv.net/member.php?id=#{userid.to_s}"
				@agent.get(uri)
				
				# ユーザが存在しなければ落とす
				if @agent.page.search('span[@class="error"]').length > 0 then
					raise ArtistNotFoundError; end
				
				Presenter::Author::Artist.new(@agent, userid)
			end
			
			# 投稿されたイラストを取得する
			# @param userid [Int] ユーザID
			# @param param [Hash]
			# @param param [Range] :range 表示させたいページ範囲
			def pictures(userid, param={})
				uri = "http://www.pixiv.net/member_illust.php?id=#{userid.to_s}"
				Presenter::Author::Array::Pictures.new(param = {:uri => uri})
			end
			
			# ブックマークに登録したユーザを取得する
			# @param userid [Int] ユーザID
			# @param param [Hash]
			# @param param [Range] :range 表示させたいページ範囲
			def bookmarks(userid, param={})
				uri = "http://www.pixiv.net/bookmark.php?id=#{userid.to_s}"
				#Presenter::Author::Array::Bookmarks.new(param = {:uri => uri})
			end
			
			# 作品に設定されたタグの取得を行う
			# @param userid [Int] ユーザID
			def tags(userid)
			
			end
			
			# お気に入りに登録されたユーザを取得する
			# @param userid [Int] ユーザID
			def favorites(userid)
			
			end
			
			# レスポンスに応じたイラストを取得する
			# @param userid [Int] ユーザID
			def responses(userid)
			
			end
			
			
		end
	end
end