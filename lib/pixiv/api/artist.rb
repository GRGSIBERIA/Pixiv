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
			
=begin
			NOTE:
			paramで利用するパラメータ引数について。
			paramはハッシュで、場合分けによって引数を使い分けたい場合に使ってます。
			中には必須の引数があるので注意してください。
			@param [String] :uri どこのページからサムネを引っ張り出すか
			@param [String] :picture_count 画像件数が書いてあるパスを指定する、inner_textで読みだされるので注意
			@param [String] :image_tag_path imgタグが存在するパスを指定
			@param [String] :invalid_img_src 無視したいimgタグのパスを指定する
			@param [String] :referer_is_two_parent pタグのせいでリファラーが祖父要素にある場合に何か入れる
=end
			
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
				param[:uri] = "http://www.pixiv.net/member_illust.php?id=#{userid.to_s}"
				param[:picture_count] = 'div[@class="two_column_body"]/h3/span'
				param[:image_tag_path] = 'div[@class="display_works linkStyleWorks"]/ul/li/a/img'
				param[:invalid_img_src] = '/source/'
				param[:a_tag_is_two_parent] = false
				GetThumbnails(param)
			end
			
			# ブックマークに登録したユーザを取得する
			# @param userid [Int] ユーザID
			# @param param [Hash]
			# @param param [Range] :range 表示させたいページ範囲
			# @return [Array<Presenter::Thumbnail>] 取得できたサムネイル一覧
			def bookmarks(userid, param={})
				param[:uri] = "http://www.pixiv.net/bookmark.php?id=#{userid.to_s}"
				param[:picture_count] = 'div[@class="two_column_body"]/h3/span'
				param[:image_tag_path] = 'div[@class="display_works linkStyleWorks"]/ul/li/a/img'
				param[:invalid_img_src] = '/source/'
				param[:bookmark_count] = true		# カウントしたいって意味
				param[:a_tag_is_two_parent] = false
				GetThumbnails(param)
			end
			
			# 投稿されたイラストに付いたタグ一覧を取得する
			# @param userid [Int] ユーザID
			def tags(userid)
				# タグの場合、微妙に形式が異なるので注意
				# 本当にタグとURIと件数だけ
				param = Hash.new
				param[:uri] = "http://www.pixiv.net/member_tag_all.php?id=#{userid.to_s}"
				GetTags(param)
			end
			
			# お気に入りに登録されたユーザを取得する
			# @param userid [Int] ユーザID
			def favorites(userid)
			
			end
			
			# レスポンスに応じたイラストを取得する
			# @param userid [Int] ユーザID
			def responses(userid)
			
			end
			
			# @param param [Hash]
			# @param param [String] :uri ユーザが付けたタグ一覧を取得しに行くためのURI
			def GetTags(param)
				# ページを取得して行ごとにタグ情報を取得してくる
				result_tags = Array.new
				@agent.get(param[:uri])
				used_tag_counts = @agent.page.search('div[@class="tagListNaviBody"]/dl/dt')
				tag_lines = @agent.page.search('div[@class="tagListNaviBody"]/dl/dd')
				
				# 1行（タグ数カウント）ごとに格納する感じ
				for line_num in 0..used_tag_counts.length-1 do
					# タグが利用されたイラスト数と実際の名前を取得して格納する
					count = used_tag_counts[line_num].inner_text.to_i
					tag_lines[line_num].search('a').each{|tag|
						result_tags << Presenter::Instance::Tag.new(
							@agent, tag.inner_text, {:used_illust_count => count})
					}
				end
				result_tags
			end
			
			# あるURIからサムネを取得する
			def GetThumbnails(param)
				pictures_array = Array.new	# いわゆる探索結果
				result = nil
				
				# 一度agentが指す位置を移動させておく
				page_num = 2
				if GetPictures(param, param[:uri], 1, 1, pictures_array) == nil
					return pictures_array
				end
				
				# 先にagent.pageを移動させておかないと使い物にならない
				max_page = GetMaxPageNum(param)
				
				# 繰り返しページを探索して配列にPictureを継ぎ足していく
				while GetPictures(param, param[:uri], page_num, max_page, pictures_array)	# 最初の1回は必ず実行される
					page_num += 1
				end
				pictures_array
			end
			
			# 何ページ存在するのか調べる
			def GetMaxPageNum(param)
				max_page_text = @agent.page.at(param[:picture_count]).inner_text
				max_page_num = max_page_text.scan(/[0-9]+/)[0].to_i
				return max_page_num.div(20) + 1
			end
			
			# 1ページからサムネを全て抜き出してpictures_arrayに入れる
			def GetPictures(param, uri, page_num, max_page, pictures_array)
				# ページを取得して存在チェック
				@agent.get(uri + "&p=#{page_num.to_s}")
				if @agent.page.body.force_encoding('UTF-8').scan("見つかりませんでした".force_encoding('UTF-8')).length > 0 then
					return nil; end
				
				# 何件の登録があるのか調べて存在するページ数か調べる
				if max_page >= page_num
					# ページごとに取得した画像を結合していく
					pictures_array.concat(GetPicturesArrayInPage(param))
				else
					nil
				end
			end
			
			# ページ内のイラストを取得する
			def GetPicturesArrayInPage(param)
				thumbnails = Array.new # 表示されている件数だけ
				img_array = @agent.page.search(param[:image_tag_path])
				for img in img_array do
					begin
						# イラストIDを抽出してサムネを追加していく
						# 無効なURIが含まれる時があるのでその時は無視する
						if !img['src'].include?(param[:invalid_img_src]) then
							arg_param = SetupArgParams(img, param)	# サムネクラスに投げるパラメータの設定
							if param[:bookmark_count] == true then	# ブクマ数を取得する
								arg_param[:bookmark_count] = GetBookmarkCount(img, param[:a_tag_is_two_parent])
							end
							thumbnails << Presenter::Image::Thumbnail.new(@agent, arg_param)
						end
					rescue Pixiv::PageNotFoundError
						break
					end
				end
				thumbnails
			end
			
			# ブクマ数をタグから探してくる
			def GetBookmarkCount(img, a_tag_is_two_parent)
				# aタグの上にpタグが挟まっている場合の処理
				path = 'ul[@class="count-list"]/li/a'
				count_list = a_tag_is_two_parent == true ? 
					img.parent.parent.parent.at(path) : img.parent.parent.at(path)
				if count_list == nil then return nil; end
				count_list['data-tooltip'].scan(/[0-9]+/)[0].to_i
			end
			
			def SetupArgParams(img, param)
				# aタグがpタグのせいで祖父ノードにある場合の処理
				img_src = img['src']
				parent_href = param[:a_tag_is_two_parent] == true ? img.parent.parent['href'] : img.parent['href']
				referer = "http://www.pixiv.net/" + parent_href
				arg_param = {
					:illust_id => img_src.scan(/[0-9]+\_s/)[0].delete('_s').to_i,
					:location => File.dirname(img_src),
					:referer => referer,
					:extension => File.extname(img_src)
				}
			end
		end
	end
end