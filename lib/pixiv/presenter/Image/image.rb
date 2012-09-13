=begin
イラストや漫画、サムネなどの共通した情報が入る
イラスト情報ページはimage_info.rbを参照
=end
require './pixiv/presenter/base.rb'
require './pixiv/parser/image.rb'

module Pixiv
	module Presenter
		module Image
			class Image < Base
				# @param [Mechanize::Page] ページ
				def initialize(agent, illust_id)
					super(agent)
					@illust_id = illust_id
					@uri = agent.page.uri
				end
				
				# @return [String] イラスト情報ページのID
				def uri
					@uri
				end
				
				# @return [String] イラストのID
				def illust_id
					@illust_id
				end
				
				# @return [String] タイトル
				def title
					@title ||= Parser::Image.title(@page)
				end
				
				# @return [String] ユーザ名
				def artist
					@artist ||= Parser::Image.artist(@page)
				end
				
				# @return [String] ユーザID
				def userid
					@userid ||= Parser::Image.userid(@page)
				end
				
				# @return [String] 実際の画像が置かれている置かれているURI
				# EXAMPLE:
				# 		http://i2.pixiv.net/img12/img/hoge123/
				def location
					@location ||= Parser::Image.location(@page) + "/"
				end
				
				# @return [String] イラストの拡張子
				# EXAMPLE:
				#		.jpg, .gif, .png
				def extension
					@extension ||= Parser::Image.extension(@page)
				end
				
				# @return [String] サムネ画像のURI
				def thumbnail_uri
					@thumbnail_uri ||= AppendedPrefixURI('_s')
				end
				
				# @return [String] イラスト情報にある画像のURI
				def medium_uri
					@medium_uri ||= AppendedPrefixURI('_m')
				end
				
				# @return [Array<Byte>] サムネイル画像のバイナリ
				def thumbnail
					@thumbnail ||= @agent.get(thumbnail_uri, nil, uri).body
				end
				
				# @return [Array<Byte>] イラスト情報ページのバイナリ
				def medium
					@medium ||= @agent.get(medium_uri, nil, uri).body
				end
				
				# @return [String] サムネのファイル名を取得する
				def thumbnail_filename
					@thumbnail_fillename ||= File.basename(thumbnail_uri)
				end
				
				# @return [String] 中くらいの画像のファイル名を取得する
				def medium_filename
					@medium_filename ||= File.basename(medium_uri)
				end
				
				# @param [String] イラストIDの後につけたい識別子的なもの
				# @return [String] 完全な画像のURI
				def AppendedPrefixURI(pref)
					 location + illust_id .to_s+ pref + extension
				end
				private :AppendedPrefixURI
			end
		end
	end
end