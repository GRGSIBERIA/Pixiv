=begin
漫画の情報が入る
=end
require './pixiv/presenter/image.rb'

module Pixiv
	module Presenter
		class Manga < Image
			# @param [Mechanize::Page] ページ
			def initialize(page, illust_id)
				super(page, illust_id)
				@large_uris = Array.new
				@big_uris = Array.new
			end
			
			# @return [Int] ページ数
			def page_count
				@page_count ||= Parser::Illust.size(@page).delete('漫画 ').delete('P').to_i
			end
			
			# @return [Array<String>] 漫画内の画像のURIの配列
			def large_uris
				for i in @large_uris.length..page_count-1 do
					@large_uris << AppendedPrefixURI('_p' + i.to_s)
				end
				@large_uris
			end
			
			# @return [Array<String>] 漫画の大きな画像のURIの配列
			def big_uris
				for i in @big_uris.length..page_count-1 do
					@big_uris << AppendedPrefixURI('_big_p' + i.to_s)
				end
				@big_uris
			end
		end
	end
end