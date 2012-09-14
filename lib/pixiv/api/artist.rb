=begin
特定のユーザ情報を問い合わせるためのクラス
=end
require './pixiv/api/base.rb'
require './pixiv/presenter/image/thumbnail.rb'

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
			
			# 作品に設定されたタグの取得を行う
			# @param userid [Int] ユーザID
			def tags(userid)
			
			end
			
			# 投稿されたイラストを取得する
			# @param userid [Int] ユーザID
			# @param param [Hash]
			# @param param [Range] :range 表示させたい範囲
			def pictures(userid, param={})
				uri = "http://www.pixiv.net/member_illust.php?id=#{userid.to_s}"
				
				GetPictures(userid, param, 1)
			end
			
			def GetPictures(uri, userid, param, times)
				# ページを取得して存在チェック
				@agent.get(uri + "&p=#{times.to_s}")
				if @agent.page.body.scan('見つかりませんでした').length > 0 then
					raise PageNotFoundError; end
				
				# 何件の登録があるのか調べて存在するページ数か調べる
				max_page = @agent.page.at('div[@class="two_column_body"]/h3/span').inner_text.scan(/[0-9]+/).to_i.div(20) + 1
				if max_page >= page
					
				else
					nil
				end
			end
			
			# 
			def GetPicturesArrayInPage
				thumbnails = Array.new # 表示されている件数だけ
				img_array = @agent.page.search('ul/li/a/img')
				for img in img_array do
					# イラストIDを抽出してサムネを追加していく
					illust_id = img['href'].scan(/[0-9]+\_s/)[0].delete('_s').to_i
					# TODO: image_typeが指定されていないので推定する方法を考える
					thumbnails << Presenter::Image::Thumbnail.new(@agent, :illust_id => illust_id)
				end
				thumbnails
			end
			
			# お気に入りに登録されたユーザを取得する
			# @param userid [Int] ユーザID
			def favorites(userid)
			
			end
			
			# レスポンスに応じたイラストを取得する
			# @param userid [Int] ユーザID
			def responses(userid)
			
			end
			
			# ブックマークに登録したユーザを取得する
			# @param userid [Int] ユーザID
			def bookmarks(userid)
			
			end
		end
	end
end