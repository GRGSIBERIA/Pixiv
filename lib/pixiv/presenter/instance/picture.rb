=begin
画像のインスタンスを扱うためのクラス
=end
require './pixiv/presenter/base.rb'

module Pixiv
	module Presenter
		module Instance
			class Picture < Base
				# @param agent [Mechanize] エージェント
				# @param illust_id [Int] イラストのID
				# @param location [String] イラストがサーバ上のどこに存在しているか
				# @param referer [String] リファラー
				# @param extension [String] 拡張子
				def initialize(agent, param = {})
					super(agent)
					@illust_id = param[:illust_id]
					@referer = param[:referer]
					@prefix = param[:prefix]
					@extension = param[:extension]
					@location = param[:location]
					@uri = uri
				end
				
				# @return [Int] イラストID
				def illust_id
					@illust_id
				end
				
				# @return [String] リファラー
				def referer
					@referer
				end
				
				# @return [Array<Byte>] サムネイル画像のバイナリ
				def binary
					@binary ||= @agent.get(uri, nil, referer).body
				end
				
				# @return [Array<Byte>] 画像の容量
				def size
					@size ||= binary.size
				end
				
				# @return [String] サムネのファイル名を取得する
				def filename
					@fillename ||= File.basename(uri)
				end
				
				# @return [String] イラストIDの後に付ける識別子
				def prefix
					@prefix
				end
				
				# @return [String] サーバの場所
				def location
					@location
				end
				
				# @return [String] サムネ画像のURI
				# EXAMPLE:
				#		http://i2.pixiv.net/img12/img/hoge123/12345.jpg
				def uri
					@uri ||= AppendedPrefixURI(prefix)
				end
				
				# @return [String] 画像の拡張子
				# EXAMPLE:
				#		.jpg, .gif, .png
				def extension
					@extension
				end
				
				# @param directory [String] 保存したいパス
				def save(directory)
					File.binwrite(directory + filename, binary)
				end
				
				# @param pref [String] イラストIDの後につけたい識別子的なもの
				# @return [String] 完全な画像のURI
				def AppendedPrefixURI(pref)
					 location + illust_id .to_s+ pref + extension
				end
				protected :AppendedPrefixURI
			end
		end
	end
end