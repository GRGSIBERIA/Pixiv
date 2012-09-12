=begin
イラストや漫画など、ある程度共通した情報が入る
=end
require './pixiv/presenter/base.rb'
require './pixiv/parser/illust.rb'

module Pixiv
	module Presenter
		class Image < Base
			# @param [Mechanize::Page] ページ
			def initialize(agent, illust_id)
				super(agent)
				@illust_id = illust_id
				@uri = agent.page.uri
			end
			
			def uri
				@uri
			end
			
			# @return [String] イラストのID
			def illust_id
				@illust_id
			end
			
			# @return [Array<String>] タグ情報の配列
			def tags
				@tags ||= Parser::Illust.tags(@page)
			end
			
			# @return [String] タイトル
			def title
				@title ||= Parser::Illust.title(@page)
			end

			# @return [String] キャプション
			def caption
				@caption ||= Parser::Illust.caption(@page)
			end
			
			# @return [String] ユーザ名
			def artist
				@artist ||= Parser::Illust.artist(@page)
			end
			
			# @return [String] ユーザID
			def userid
				@userid ||= Parser::Illust.userid(@page)
			end
			
			# @return [String] 投稿した日付
			def date
				@date ||= Parser::Illust.date(@page)
			end
			
			# @return [Array<String>] 使用したツール
			def tools
				@tools ||= Parser::Illust.tools(@page)
			end
			
			# @return [Int] イラストの閲覧数
			def view_count
				@view_count ||= Parser::Illust.view_count(@page)
			end
			
			# @return [Int] イラストの評価回数
			def rated_count
				@rated_count ||= Parser::Illust.rated_count(@page)
			end
			
			# @return [Int] 総合点数
			def score_count
				@score_count ||= Parser::Illust.score_count(@page)
			end
			
			# @return [String] 実際の画像が置かれている置かれているURI
			# EXAMPLE:
			# 		http://i2.pixiv.net/img12/img/hoge123/
			def location
				@location ||= Parser::Illust.location(@page) + "/"
			end
			
			# @return [String] イラストの拡張子
			# EXAMPLE:
			#		.jpg, .gif, .png
			def extension
				@extension ||= Parser::Illust.extension(@page)
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