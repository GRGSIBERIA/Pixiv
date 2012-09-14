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
				# @param param [String] :image_type 画像の種類
				def initialize(agent, param={})
					super(agent, illust_id, "thumbnail")
					param[:bookmark_count] ||= -1
					param[:image_type] ||= raise ArgumentError, "サムネ画像がイラストか漫画なのかなぜかわからない"
					@bookmark_count = param[:bookmark_count]
					@image_type = param[:image_type]
				end
			
				# @return [Int] ブクマ数
				# NOTE: -1は不明
				def bookmark_count
					@bookmark_count
				end
				
				# @return [String] イラストか、マンガか
				# NOTE: illust, manga
				def image_type
					@image_type
				end
			end
		end
	end
end