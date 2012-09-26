=begin
リスト表示になっているサムネイルの取得を行うためのユーティリティクラス
取得と同時にgetでアクセスもするので注意
=end
require 'mechanize'
require './pixiv/presenter/listing.rb'

=begin
			NOTE:
			paramで利用するパラメータ引数について。
			paramはハッシュで引数を使い分けたい場合に使ってます。
			中には必須の引数があるので注意してください。
			@param [String] :uri どこのページからサムネを引っ張り出すか
			@param [Range] :range どこのページからどこのページを読み込むか, 最初のページは1。（任意）
			@param [String] :picture_count 画像件数が書いてあるパスを指定する、inner_textで読みだされるので注意
			@param [String] :image_tag_path imgタグが存在するパスを指定
			@param [Bool] :a_tag_is_two_parent imgタグからaタグまで親が2つ存在しているかどうかのフラグ
			@param [Bool] :do_bookmark_count ブクマのカウントを行うかどうかのフラグ
			@param [Int]: custom_max_page_count そのページに存在し、取得もしたい画像の数
=end


module Pixiv
	module Parser
		class Listing
			def initialize(agent)
				@agent = agent
			end
		
			# あるURIからサムネを取得する
			# @param param [Hash]
			# @return [Presenter::Listing] 一覧
			def GetThumbnails(param)
				@agent.get(param[:uri])	# 一度最初のページを取得して最大ページ数を取得しておく
				pictures_array = Array.new	# いわゆる探索結果
				
				# 検索する範囲を設定する
				content_count = GetContentCount(param)
				max_page = GetMaxPageNum(param, content_count)
				range = RoundRange(param[:range], max_page)	# :page_num, :max_page
								
				# 繰り返しページを探索して配列にPictureを継ぎ足していく
				for page_num in range do
				#while GetPictures(param, range[:page_num], range[:max_page], pictures_array)	# 最初の1回は必ず実行される
					# 1ページごとに洗い出しながら、サムネを拾ってインスタンス化していく
					@agent.get(param[:uri] + "&p=#{page_num.to_s}")
					if @agent.page.body.force_encoding('UTF-8').scan("見つかりませんでした".force_encoding('UTF-8')).length > 0 then
						return nil; end

					GetPictures(param, page_num, pictures_array)
				end
				
				Presenter::Listing.new(@agent, "thumbnail", pictures_array, {
					:page_count => max_page, 
					:range => range,
					:in_page_count => param[:custom_max_page_count],		# 先にGetMax～を呼ばないと死ぬ
					:content_count => content_count})
			end
			
			# ユーザ情報一覧を取得する
			# @param param [Hash]
			# @param param [String] :uri 取得しに行きたいURI
			# @param param [Range] :range 表示するページ数
			# @return [Presenter::Listing] 一覧
			def GetUsers(param)
				@agent.get(param[:uri])	# 一度最初のページを取得して最大ページ数を取得しておく
				result_users = Array.new
				
				content_count = GetContentCount(param)
				max_page = GetMaxPageNum(param, content_count)
				wash_pages = RoundRange(param[:range], max_page)
				
				for page_num in wash_pages do
					# 1ページごとに洗い出しながら、サムネを拾ってインスタンス化していく
					@agent.get(param[:uri] + "&p=#{page_num}")
					if @agent.page.body.force_encoding('UTF-8').scan("見つかりませんでした".force_encoding('UTF-8')).length > 0 then
						return nil; end
					users = @agent.page.search(param[:image_tag_path])
					for user in users do
						result_users << MakeUserIcon(user)
					end
				end
				
				Presenter::Listing.new(@agent, "icon", result_users, {
					:page_count => max_page, 
					:range => wash_pages,
					:in_page_count => param[:custom_max_page_count],		# 先にGetMax～を呼ばないと死ぬ
					:content_count => content_count})
			end
			
			# 何ページ存在するのか調べる
			# @param content_count どれぐらいコンテンツが存在しているか
			# @param param [Hash]
			# @return [Int] 最大ページ数
			def GetMaxPageNum(param, content_count)
				div_count = param[:custom_max_page_count] ||= 20	# 指定がなければデフォルトで20件
				content_count.div(div_count) + 1
			end
			
			# @param param [Hash]
			# @return [Int] 全体としてどれぐらいコンテンツの数が存在しているか
			def GetContentCount(param)
				contents_count_text = @agent.page.at(param[:picture_count]).inner_text
				contents_num = contents_count_text.scan(/[0-9]+/)[0].to_i
			end
			
			# 1ページからサムネを全て抜き出してpictures_arrayに入れる
			# @param param [Hash]
			# @param page_num [Int] ページ番号
			# @param pictures_array [Array<Presenter::Image::Thumbnail>] サムネの結果を格納するための配列
			def GetPictures(param, page_num, pictures_array)
				# ページを取得して存在チェック
				@agent.get(param[:uri] + "&p=#{page_num.to_s}")
				if @agent.page.body.force_encoding('UTF-8').scan("見つかりませんでした".force_encoding('UTF-8')).length > 0 then
					return nil; end
				
				# 何件の登録があるのか調べて存在するページ数か調べる
				# ページごとに取得した画像を結合していく
				pictures_array.concat(GetPicturesArrayInPage(param))
			end
			
			# ページ内のイラストを取得する
			# @param param [Hash]
			# @return [Array<Presenter::Image::Thumbnail>] ページ内に存在しているサムネ
			def GetPicturesArrayInPage(param)
				thumbnails = Array.new # 表示されている件数だけ
				img_array = @agent.page.search(param[:image_tag_path])
				for img in img_array do
					begin
						# イラストIDを抽出してサムネを追加していく
						# 無効なURIが含まれる時があるのでその時は無視する
						if img['src'].include?('pixiv.net/img') then
							arg_param = SetupArgParams(img, param)	# サムネクラスに投げるパラメータの設定
							
							thumbnails << Presenter::Image::Thumbnail.new(@agent, arg_param)
						end
					rescue Pixiv::PageNotFoundError
						next		# 取得できるものだけ取得したいので何もせずに無視する
					end
				end
				thumbnails
			end
			
			# ブクマ数をタグから探してくる
			# @param img [Nokogiri::Element] imgタグを示す要素
			# @param a_tag_is_two_parent [Bool] trueならばimgタグから見てaタグが2階層上にある
			# @param do_bookmark_count [Bool]
			def GetBookmarkCount(img, a_tag_is_two_parent, do_bookmark_count)
				if do_bookmark_count == true then
					# aタグの上にpタグが挟まっている場合の処理
					path = 'ul[@class="count-list"]/li/a'
					count_list = a_tag_is_two_parent == true ? 
						img.parent.parent.parent.at(path) : img.parent.parent.at(path)
					if count_list == nil then return nil; end
					count_list['data-tooltip'].scan(/[0-9]+/)[0].to_i
				else
					nil	# カウントしない場合はnil
				end
			end
			
			# @param img [Nokogiri::Element] imgタグの場所
			# @param param [Hash]
			def SetupArgParams(img, param)
				# aタグがpタグのせいで祖父ノードにある場合の処理
				img_src = img['src']
				parent_href = param[:a_tag_is_two_parent] == true ? img.parent.parent['href'] : img.parent['href']
				referer = "http://www.pixiv.net/" + parent_href
				do_bookmark_count = GetBookmarkCount(img, param[:a_tag_is_two_parent], param[:bookmark_count])
				arg_param = {
					:illust_id => img_src.scan(/[0-9]+\_s/)[0].delete('_s').to_i,
					:location => File.dirname(img_src),
					:referer => referer,
					:extension => File.extname(img_src),
					:bookmark_count => do_bookmark_count
				}
			end
			
			# 指定した範囲にまとめる
			# @param view_range [Range] paramで指定された表示範囲
			# @param max_page [Int] 最大ページ数
			# @return [Range] 丸めた後のページ範囲
			def RoundRange(view_range, max_page)
				start =1
				last = max_page
				if view_range != nil then
					start = view_range.first >= 1 ? view_range.first : 1
					last = view_range.last > max_page ? max_page : view_range.last
				end
				start..last
			end
			
			# ユーザのアイコン情報を生成する
			# @param user_icon [Nokogiri::Element] アイコンのimgタグ
			# @return [Presenter::Author::Icon]
			def MakeUserIcon(user_icon)
				user_id = user_icon.parent['href'].delete!('member.php?id=').to_i
				nickname = user_icon['alt']
				
				icon = MakeUserIconImage(user_icon)
				Presenter::Author::Icon.new(@agent, user_id, nickname, icon)
			end
			
			# ユーザのアイコンサムネを拾ってくるためのコード
			# @param user [Nokogiri::Element] アイコンのimgタグ
			# @param illust_id [Int] イラストのID
			# @return [Presenter::Instance::Picture] ユーザのミニアイコン
			def MakeUserIconImage(user)
				illust_id = File.basename(user['src'], ".*").sub!(/(_80)$/, "").to_i
				param = {
					:illust_id => illust_id,
					:referer => @agent.page.uri.to_s,
					:extension => File.extname(user['src']),
					:prefix => '_80',
					:location => File.dirname(user['src']) + "/"
				}
				Presenter::Instance::Picture.new(@agent, param)
			end
		end
	end
end