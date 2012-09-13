=begin
漫画やイラストなどの情報ページ
=end
require './pixiv/presenter/image.rb'

module Pixiv
	module Presenter
		class ImageInfo < Image
			def initialize(agent, illust_id)
				super(agent, illust_id)
			end
			
			# @return [Array<String>] タグ情報の配列
			def tags
				@tags ||= Parser::Image.tags(@page)
			end
			
			# @return [String] キャプション、説明
			def caption
				@caption ||= Parser::Image.caption(@page)
			end
			
			# @return [String] 投稿した日付
			def date
				@date ||= Parser::Image.date(@page)
			end
			
			# @return [Array<String>] 使用したツール
			def tools
				@tools ||= Parser::Image.tools(@page)
			end
			
			# @return [Int] イラストの閲覧数
			def view_count
				@view_count ||= Parser::Image.view_count(@page)
			end
			
			# @return [Int] イラストの評価回数
			def rated_count
				@rated_count ||= Parser::Image.rated_count(@page)
			end
			
			# @return [Int] 総合点数
			def score_count
				@score_count ||= Parser::Image.score_count(@page)
			end
		end
	end
end