=begin
漫画の情報が入る
=end
require './pixiv/presenter/image.rb'

module Pixiv
	module Presenter
		class Manga < Image
			# @param [Mechanize::Page] ページ
			def initialize(agent, illust_id)
				super(agent, illust_id)
				@large_uris = Array.new(page_count, nil)
				@big_uris = Array.new(page_count, nil)
				@large = Array.new(page_count, nil)
				@big = Array.new(page_count, nil)
			end
			
			# @return [Int] ページ数
			def page_count
				@page_count ||= Parser::Illust.size(@page).delete('漫画 ').delete('P').to_i
			end
			
			# @return [Array<String>] 漫画内の画像のURIの配列
			def large_uris
				for i in 0..page_count-1 do
					@large_uris[i] ||= AppendedPrefixURI('_p' + i.to_s)
				end
				@large_uris
			end
			
			# @return [Array<String>] 漫画の大きな画像のURIの配列
			def big_uris
				for i in 0..page_count-1 do
					@big_uris[i] ||= AppendedPrefixURI('_big_p' + i.to_s)
				end
				@big_uris
			end
			
			# @return [Array<Array<Byte>>] 漫画の画像のバイナリを取得してくる
			# NOTE: 一気に取得するので注意
			def large
				for i in 0..page_count-1 do large(i) end
				@large
			end
			
			# @param i 画像の番号
			# @return [Array<Byte>] 漫画の画像を個別に取得してくる
			def large(num)
				@large[num] ||= @agent.get(large_uris[num], nil, uri).body
			end
			
			# @return [Array<Array<Byte>>] 漫画の大きな画像のバイナリを取得してくる
			def big
				for i in 0..page_count-1 do big(i) end
				@big
			end
			
			# @param i 画像の番号
			# @return [Array<Byte>] 漫画の大きな画像を個別に取得してくる
			def big(num)
				@big[num] ||= @agent.get(big_uris[num], nil, uri).body
			end
		end
	end
end