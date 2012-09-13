=begin
サムネイル画像のクラス
主に検索結果などで表示される奴
=end
require './pixiv/presenter/image.rb'

module Pixiv
	module Presenter
		class Thumbnail < Image
			def initialize(agent, illust_id)
				super(agent, illust_id)
			end
		
			# @param [Int] ブクマ数
			# NOTE: -1は不明
			def bookmark_count
			
			end
			
			# @param [String] イラストか、マンガか
			def image_type
			
			end
		end
	end
end