=begin
Pixivのイラスト情報をまとめておくためのクラス
=end
require './pixiv/presenter/image.rb'
require './pixiv/parser/illust.rb'

module Pixiv
	module Presenter
		# イラスト情報を格納するためのクラス
		class Illust < Image
			# @param [Mechanize::Page] ページ
			def initialize(agent, illust_id)
				super(agent, illust_id)
			end
		
			# @return [String] イラストの大きさ、もしくはページ枚数
			def size
				@size ||= Parser::Illust.size(@page)
			end
			
			# @return [Int] 画像の横幅
			def width
				if @width == nil then
					@width = size.split('×')[0].to_i
				end
				@width
			end
			
			# @return [Int] 画像の縦幅
			def height
				if @height == nil then
					@height = size.split('×')[1].to_i
				end
				@height
			end
			
			# @return [String] もっと大きな画像のURI
			def large_uri
				@large_uri ||= AppendedPrefixURI("")
			end
			
			# @return [Array<Byte>] 大きめの画像のバイナリを取得する
			def large
				@large ||= @agent.get(large_uri, nil, uri).body
			end
			
			# @return [String] 大きな画像のファイル名のみ取得
			def large_filename
				@large_filename ||= File.basename(large_uri)
			end
		end
	end
end