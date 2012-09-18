=begin
イラストや漫画、サムネなどの共通した情報が入る
イラスト情報ページはimage_info.rbを参照
=end
require './pixiv/presenter/base.rb'
require './pixiv/parser/image.rb'
require './pixiv/presenter/instance/picture.rb'

module Pixiv
	module Presenter
		module Image
			class Image < Base
				# @param [Mechanize::Page] ページ
				def initialize(agent, illust_id, picture_type)
					super(agent)
					@illust_id = illust_id
					@uri = agent.page.uri
					@type = picture_type
					@referer = @uri
				end
				
				# イラスト情報ページを保存する
				# @param directory [String] 保存先のディレクトリ
				def save(directory)
					File.write(directory + illust_id.to_s + ".html", @page.body)
				end
				
				# @return [String] 画像のタイプ
				# NOTE: 
				def type
					@type
				end
				
				# @return [String] イラスト情報ページのID
				def uri
					@uri
				end
				
				def referer
					@referer
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
				
				# @return [Presenter::Instance::Picture] サムネ画像
				def thumbnail
					@thumbnail ||= CreatePicture("_s")
				end
				
				# @return [Presenter::Instance::Picture] イラスト情報画面の画像
				def medium
					@medium ||= CreatePicture("_m")
				end
				
				# @param [String] イラストIDの後に付ける奴
				# @param [String] 拡張子、自由につけたい場合は
				# @return [Presenter::Instance::Picture] 画像インスタンス
				def CreatePicture(prefix, ext=nil)
					if ext == nil then ext = extension end
					arg = {	
						:illust_id => illust_id, 
						:location => location, 
						:referer => @referer, 
						:prefix => prefix,
						:extension => ext}
					Presenter::Instance::Picture.new(@agent, arg)
				end
				protected :CreatePicture
			end
		end
	end
end