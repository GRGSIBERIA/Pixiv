=begin
漫画やイラストなどの情報ページ
=end
require './pixiv/presenter/image/image.rb'
require './pixiv/presenter/instance/tag.rb'

module Pixiv
	module Presenter
		module Image
			class ImageInfo < Image
				def initialize(agent, illust_id, picture_type)
					super(agent, illust_id, picture_type)
					@tags = Array.new
				end
				
				# @return [Array<Presenter::Instance::Tag>] タグ情報の配列
				def tags
					# 取得できたタグを走査して、タグ情報をTagクラスに入れていく
					if @tags.length <= 0 then
					  Parser::Image.tags(@page).each{|tag| 
					    @tags << Presenter::Instance::Tag.new(@agent, tag)
					  }
					end
					@tags
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
end