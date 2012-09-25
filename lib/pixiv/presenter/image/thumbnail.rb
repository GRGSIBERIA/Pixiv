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
				# @param param [Int] :illust_id イラストID (require)
				# @param param [Int] :bookmark_count ブックマーク数
				# @param param [String] :thumbnail_type サムネイルの種類, bookmark, tag, searchなど
				# @param param [String] :location サーバ上の位置
				# @param param [String] :extension 拡張子、事前に入れておく
				def initialize(agent, param={})
					super(agent, param[:illust_id], "thumbnail")
					# 値が存在しなくてもOKな奴
					param[:bookmark_count] ||= -1
					param[:illust_title] ||= ""
					param[:illust_author] ||= ""
					@bookmark_count = param[:bookmark_count]
					@extension = param[:extension]
					@illust_title = param[:illust_title]
					@artist = param[:illust_author]
					
					# 漫画用配列
					@larges = Array.new
					@bigs = Array.new
					
					# 強制的にサーバ上の位置を再設定する
					if param[:location] != nil then
						@location = param[:location] + "/"
					end
					
					# リファラーがあった場合、そっちに再設定する
					if param[:referer] != nil then
						@referer = param[:referer]
					end
				end
				
				# @return [String] 作品名
				def title
					@illust_title
				end
				
				# @return [String] 投稿者名
				def artist 
					@artist
				end
				
				# サムネ画像の拡張子を取得するコード
				def extension
					@extension
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
				
				# とにかく何でもいいから取得する
				# @return [Presenter::Instance::Picture] イラスト用の画像
				# @return [Array<Presenter::Instance::Picture] 漫画用の画像配列
				def picture
					# どちらかをテスト
					if large != nil then	# イラストがなかったら漫画で試す
						return large
					elsif	larges != nil then
						return larges
					else
						raise IllustNotFoundError, "イラストが見つかりません"
					end
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