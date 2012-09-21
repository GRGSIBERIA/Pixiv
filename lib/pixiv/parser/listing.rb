=begin
リスト表示になっているサムネイルの取得を行うためのユーティリティクラス
取得と同時にgetでアクセスもするので注意
=end
require 'mechanize'

=begin
			NOTE:
			paramで利用するパラメータ引数について。
			paramはハッシュで、場合分けによって引数を使い分けたい場合に使ってます。
			中には必須の引数があるので注意してください。
			@param [String] :uri どこのページからサムネを引っ張り出すか
			@param [Range] :range どこのページからどこのページを読み込むか, 最初のページは0扱いにする
			@param [String] :picture_count 画像件数が書いてあるパスを指定する、inner_textで読みだされるので注意
			@param [String] :image_tag_path imgタグが存在するパスを指定
			@param [String] :a_tag_is_two_parent imgタグからaタグまで親が2つ存在しているかどうかのフラグ
=end


module Pixiv
	module Parser
		class Listing
			def initialize(agent)
				@agent = agent
			end
		
			# あるURIからサムネを取得する
			def GetThumbnails(param)
				pictures_array = Array.new	# いわゆる探索結果
				@agent.get(param[:uri])	# 一度最初のページを取得して最大ページ数を取得しておく
				
				# 検索する範囲を設定する
				max_page = GetMaxPageNum(param)
				range = SetRange(param[:range], max_page)	# :page_num, :max_page
				
				# 繰り返しページを探索して配列にPictureを継ぎ足していく
				while GetPictures(param, range[:page_num], range[:max_page], pictures_array)	# 最初の1回は必ず実行される
					range[:page_num] += 1
				end
				pictures_array
			end
			
			# 検索範囲の設定
			# @param range [Range] 検索範囲、nilの場合もある
			# @param max_page [Int] 何ページ存在するか
			# @return [Hash] 最初のページと最後のページ, 最初のページはイテレータとして利用する
			def SetRange(range, max_page)
				result = Hash.new
				if range != nil then
					result[:page_num] = max_page < range.first ? max_page : range.first
					result[:max_page] = max_page < range.last ? max_page : range.last
				else
					result[:page_num] = 1
					result[:max_page] = max_page
				end
				result
			end
			
			# 何ページ存在するのか調べる
			def GetMaxPageNum(param)
				max_page_text = @agent.page.at(param[:picture_count]).inner_text
				max_page_num = max_page_text.scan(/[0-9]+/)[0].to_i
				max_page_num.div(20) + 1
			end
			
			# 1ページからサムネを全て抜き出してpictures_arrayに入れる
			def GetPictures(param, page_num, max_page, pictures_array)
				# ページを取得して存在チェック
				@agent.get(param[:uri] + "&p=#{page_num.to_s}")
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
			def GetBookmarkCount(img, a_tag_is_two_parent, do_count)
				if do_count != nil then
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
		end
	end
end