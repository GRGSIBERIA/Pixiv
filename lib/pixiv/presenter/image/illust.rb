=begin
Pixivのイラスト情報をまとめておくためのクラス
=end
require './pixiv/presenter/image/image_info.rb'
require './pixiv/parser/image.rb'

module Pixiv
	module Presenter
		module Image
			# イラスト情報を格納するためのクラス
			class Illust < ImageInfo
				# @param [Mechanize::Page] ページ
				def initialize(agent, illust_id)
					super(agent, illust_id, "illust")
					@type = "illust"
				end
				
				# @return [Int] 画像の横幅
				def width
					@width ||= Parser::Image.size(@page).split('×')[0].to_i
				end
				
				# @return [Int] 画像の縦幅
				def height
					@height ||= Parser::Image.size(@page).split('×')[1].to_i
				end
				
				# @return [Array<Byte>] 大きめの画像のバイナリを取得する
				def large
					@large ||= CreatePicture("")
				end
			end
		end
	end
end