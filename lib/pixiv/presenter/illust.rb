=begin
Pixivのイラスト情報をまとめておくためのクラス
=end
require './pixiv/presenter/base.rb'
require './pixiv/parser/illust.rb'

module Pixiv
	module Presenter
		# イラスト情報を格納するためのクラス
		class Illust < Base
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
			
			# @return [Int] ユーザID
			def userid
				@userid ||= Parser::Illust.userid(@page)
			end
			
			# @return [Date] 投稿した日付
			def date
			
			end
			
			# @return [String] イラストの大きさ
			def size
			
			end
			
			# @return [Array<String>] 使用したツール
			def tools
			
			end
			
			# @return [Int] イラストの閲覧数
			def view_count
			
			end
			
			# @return [Int] イラストの評価回数
			def evaluation_count
			
			end
			
			# @return [Int] 総合点数
			def total_points
			
			end
		end
	end
end