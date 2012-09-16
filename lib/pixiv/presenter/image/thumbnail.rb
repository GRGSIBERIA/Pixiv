=begin
サムネイル画像のクラス
主に検索結果などで表示される奴
=end
require './pixiv/presenter/image/image.rb'

module Pixiv
	module Presenter
		module Image
			class Thumbnail < Image
				# @param agent [Mechanize] エージェント
				# @param param [Hash] 引数パラメータ
				# @param param [Int] :illust_id イラストID
				# @param param [Int] :bookmark_count ブックマーク数
				def initialize(agent, param={})
					super(agent, illust_id, "thumbnail")
					param[:bookmark_count] ||= -1
					param[:image_type] ||= raise ArgumentError, "サムネ画像がイラストか漫画なのかなぜかわからない"
					@bookmark_count = param[:bookmark_count]
					@larges = Array.new
					@bigs = Array.new
					# 画像の種類はリンク上からでは拾うことができない
					#@image_type = param[:image_type]
				end
			
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