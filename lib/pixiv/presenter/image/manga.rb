=begin
漫画の情報が入る
=end
require './pixiv/presenter/image/image_info.rb'

module Pixiv
	module Presenter
		module Image
			class Manga < ImageInfo
				# @param [Mechanize::Page] ページ
				def initialize(agent, illust_id)
					super(agent, illust_id, "manga")
					@large = Array.new(page_count, nil)
					@big = Array.new(page_count, nil)
					@type = "manga"
				end
				
				# @return [Int] ページ数
				def page_count
					@page_count ||= Parser::Image.size(@page).delete('漫画 ').delete('P').to_i
				end

				# @return [Array<Array<Byte>>] 漫画の画像のバイナリを取得してくる
				# NOTE: 一気に取得するので注意
				def larges
					for i in 0..page_count-1 do large(i) end
					@large
				end
				
				# @param num [Int] 画像の番号
				# @return [Array<Byte>] 漫画の画像を個別に取得してくる
				def large(num)
					@large[num] ||= CreatePicture("_p#{num}")
				end
				
				# @return [Array<Array<Byte>>] 漫画の大きな画像のバイナリを取得してくる
				def bigs
					for i in 0..page_count-1 do big(i) end
					@big
				end
				
				# @param num [Int] 画像の番号
				# @return [Array<Byte>] 漫画の大きな画像を個別に取得してくる
				def big(num)
					@big[num] ||= CreatePicture("_big_p#{num}")
				end
			end
		end
	end
end