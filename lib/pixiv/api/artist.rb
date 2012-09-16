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
				pictures_array = Array.new	# いわゆる探索結果
				result = nil
				
				# ページを移動させる
				page_num = 2
				if GetPictures(uri, 1, 1, pictures_array) == nil
					return pictures_array
				end
				
				# 先にagent.pageを移動させておかないと使い物にならない
				max_page = GetMaxPageNum()
				
				while GetPictures(uri, page_num, max_page, pictures_array)	# 最初の1回は必ず実行される
					page_num += 1
				end
				pictures_array
			end
			
			# 何ページ存在するのか調べる
			def GetMaxPageNum()
				max_page_text = @agent.page.at('div[@class="two_column_body"]/h3/span').inner_text
				max_page_num = max_page_text.scan(/[0-9]+/)[0].to_i
				return max_page_num.div(20) + 1
			end
			
			# 1ページからサムネを全て抜き出してpictures_arrayに入れる
			def GetPictures(uri, page_num, max_page, pictures_array)
				# ページを取得して存在チェック
				@agent.get(uri + "&p=#{page_num.to_s}")
				if @agent.page.body.force_encoding('UTF-8').scan("見つかりませんでした".force_encoding('UTF-8')).length > 0 then
					return nil; end
				
				# 何件の登録があるのか調べて存在するページ数か調べる
				if max_page >= page_num
					# ページごとに取得した画像を結合していく
					pictures_array.concat(GetPicturesArrayInPage())
				else
					nil
				end
			end
			
			# ページ内のイラストを取得する
			def GetPicturesArrayInPage()
				thumbnails = Array.new # 表示されている件数だけ
				img_array = @agent.page.search('ul/li/a/img')
				for img in img_array do
					begin
						# イラストIDを抽出してサムネを追加していく
						illust_id = img['src'].scan(/[0-9]+\_s/)[0].delete('_s').to_i
						thumbnails << Presenter::Image::Thumbnail.new(@agent, param = {:illust_id => illust_id})
					rescue Pixiv::PageNotFoundError
						break
					end
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