=begin
サムネイル画像のクラス
主に検索結果などで表示される奴
=end
require './pixiv/presenter/image/image.rb'
require './pixiv/parser/author.rb'

module Pixiv
	module Presenter
		module Image
			class Thumbnail < Image
				# @param agent [Mechanize] エージェント
				# @param param [Hash] 引数パラメータ
				# @param param [Int] :illust_id イラストID
				# @param param [Int] :bookmark_count ブックマーク数
				# @param param [String] :thumbnail_type サムネイルの種類, bookmark, tag, searchなど
				# @param param [String] :location
				def initialize(agent, param={})
					super(agent, param[:illust_id], "thumbnail")
					param[:bookmark_count] ||= -1
					@bookmark_count = param[:bookmark_count]
					@larges = Array.new
					@bigs = Array.new
					
					# サムネがブックマークからだった場合
					if param[:thumbnail_type] == "bookmark" then
						# 強制的にサーバ上の位置を再設定する
						@location = param[:location]
					end
				end
				
				# サムネ画像の拡張子を取得するコード
				def extension
					# ページごとに判断する
					if @page.uri.request_uri.include?("member_illust") then
						@extension ||= Parser::Author.extension(@page, @illust_id)
					elsif @page.uri.request_uri.include?("bookmark") then
						@extension ||= Parser::Author.extension(@page, @illust_id)
					elsif @page.uri.request_uri.include?("tags") then
						# 未実装
						raise NotImplementedError
					elsif @page.uri.request_uri.include?("search") then
						raise NotImplementedError
					end
				end
				
				# ユーザ情報なのか検索ページなのか判断し
				# 適切なサムネを見つけるためにオーバーライドしてる
				# @param [String] イラストIDの後に付ける奴
				# @return [Presenter::Instance::Picture] 画像インスタンス
				def CreatePicture(prefix)
					arg = {	
						:illust_id => illust_id, 
						:location => location, 
						:referer => uri, 
						:prefix => prefix,
						:extension => extension}
					Presenter::Instance::Picture.new(@agent, arg)
				end
				private :CreatePicture
			
				# @return [Int] ブクマ数
				# NOTE: -1は不明
				def bookmark_count
					@bookmark_count
				end
				
				# イラスト用の大きな画像を生成する
				# @return [Presenter::Instance::Picture] イラストの大きな画像
				def large
					@large ||= CreatePicture("")
				end
				
				# サムネからは漫画のページ数が見えないためめくら打ちする
				# @param repeat_times [Int] 漫画に対する試行回数
				# @return [Presenter::Instance::Picture] 漫画の大きな画像配列
				def bigs(repeat_times=1)
					if @bigs.length > 0 then
						@bigs ||= repeat_times.times{|i|
							@bigs << CreatePicture("_big_p#{i.to_s}_")
						}
					end
				end
				
				# サムネからは漫画のページ数が見えないためめくら打ちする
				# @param repeat_times [Int] 漫画に対する試行回数
				# @return [Presenter::Instance::Picture] 漫画の画像配列
				def larges(repeat_times=1)
					if @bigs.length > 0 then
						@larges ||= repeat_times.times{|i|
							@larges << CreatePicture("_p#{i.to_s}_")
						}
					end
				end
			end
		end
	end
end