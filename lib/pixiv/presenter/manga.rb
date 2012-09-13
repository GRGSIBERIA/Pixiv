=begin
漫画の情報が入る
=end
require './pixiv/presenter/image_info.rb'

module Pixiv
	module Presenter
		class Manga < ImageInfo
			# @param [Mechanize::Page] ページ
			def initialize(agent, illust_id)
				super(agent, illust_id)
				@large_uri = Array.new(page_count, nil)
				@big_uri = Array.new(page_count, nil)
				@large = Array.new(page_count, nil)
				@big = Array.new(page_count, nil)
				@large_filename = Array.new(page_count, nil)
				@big_filename = Array.new(page_count, nil)
			end
			
			# @return [Int] ページ数
			def page_count
				@page_count ||= Parser::Image.size(@page).delete('漫画 ').delete('P').to_i
			end
			
			# @return [Array<String>] 漫画内の画像のURIの配列
			def large_uris
				for i in 0..page_count-1 do large_uri(i) end
				@large_uri
			end
			
			# @param num [Int] 漫画のページ数
			# @return [Array<String>] 漫画の画像のURIを個別に取得
			def large_uri(num)
				@large_uri[num] ||= AppendedPrefixURI('_p' + num.to_s)
			end
			
			# @return [Array<String>] 漫画の大きな画像のURIの配列
			def big_uris
				for i in 0..page_count-1 do big_uri(i) end
				@big_uri
			end
			
			# @param num [Int] 漫画のページ数
			# @return [Array<String>] 漫画の大きな画像のURIを個別に取得
			def big_uri(num)
				@big_uri[num] ||= AppendedPrefixURI('_big_p' + num.to_s)
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
				@large[num] ||= @agent.get(large_uris[num], nil, uri).body
			end
			
			# @return [Array<Array<Byte>>] 漫画の大きな画像のバイナリを取得してくる
			def bigs
				for i in 0..page_count-1 do big(i) end
				@big
			end
			
			# @param num [Int] 画像の番号
			# @return [Array<Byte>] 漫画の大きな画像を個別に取得してくる
			def big(num)
				@big[num] ||= @agent.get(big_uris[num], nil, uri).body
			end
			
			# @return [Array<String>] 漫画の画像のファイル名
			def large_filenames
				for i in 0..page_count-1 do large_filename(i) end
				@large_filename
			end
			
			# @param num [Int] 取得したい漫画のページ数
			# @return [Array<String>] 個別のページのファイル名を取得する
			def large_filename(num)
				@large_filename[num] ||= File.basename(large_uri(num))
			end
			
			# @param num [Int] 取得したい漫画のページ数
			# @return [Array<String>] 大きめの漫画のファイル名の配列を返す
			def big_filenames
				for i in 0..page_count-1 do big_filename(i) end
				@big_filename
			end
			
			def big_filename(num)
				@big_filename[num] ||= File.basename(big_uri(num))
			end
		end
	end
end