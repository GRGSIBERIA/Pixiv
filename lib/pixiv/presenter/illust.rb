=begin
Pixivのイラスト情報をまとめておくためのクラス
=end
require './pixiv/presenter/base.rb'
require './pixiv/parser/illust.rb'

module Pixiv
	module Presenter
		# イラスト情報を格納するためのクラス
		class Illust < Base
			# @param [Mechanize::Page] ページ
			def initialize(page)
				super(page)
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
			
			# @return [String] イラストの大きさ、もしくはページ枚数
			def size
				@size ||= Parser::Illust.size(@page)
			end
			
			def page_count
				@page_count = size.
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
		end
	end
end