=begin
アーティストのイラスト情報を
配列として扱えるようにするためのベースクラス
=end
require 'mechanize'

module Pixiv
	module Presenter
		module Author
			module Array
				class Base
					# @param param [Hash]
					# @param param [String] :uri member_illust.phpやbookmark.phpなどのパス
					def initialize(param)
						@param = param
						
						@thumbnails = GetThumbnails(param[:uri])
					end
					
					# 演算子のオーバーロード
					# @param ids [Int] 添え字引数
					def [](ids)
						@thumbnails[ids]
					end
					
					# あるURIからサムネを取得する
					def GetThumbnails(uri, param)
						pictures_array = Array.new	# いわゆる探索結果
						result = nil
						
						# 一度agentが指す位置を移動させておく
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
						img_array = @agent.page.search('div[@class="display_works linkStyleWorks"]/ul/li/a/img')
						for img in img_array do
							begin
								# イラストIDを抽出してサムネを追加していく
								img_src = img['src']
								if img_src.include?('/source/images/') then break end
								arg_param = {
									:illust_id => img_src.scan(/[0-9]+\_s/)[0].delete('_s').to_i,
									:location => File.dirname(img_src)
								}
								thumbnails << Presenter::Image::Thumbnail.new(@agent, param = arg_param)
							rescue Pixiv::PageNotFoundError
								break
							end
						end
						thumbnails
					end
				end
			end
		end
	end
end