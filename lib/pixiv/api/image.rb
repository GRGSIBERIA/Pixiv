=begin
特定のイラスト情報を問い合わせるためのクラス
=end
require './pixiv/api/base.rb'
require './pixiv/presenter/image/illust.rb'
require './pixiv/presenter/image/manga.rb'
require 'net/http'
require 'uri'

module Pixiv
	module API
		class Image < Base
			# @param agent [Mechanize] セッションの確立している状態のもの
			def initialize(agent)
				super(agent)
			end
		
			# あるイラスト情報のあるページをクロールしに行く
			# @param illust_id [Int] 情報を取得するイラストID
			# @return [Presenter::Image] 取得したイラスト情報
			def info(illust_id)
				uri = "http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{illust_id.to_s}"
				@agent.get(uri)
				
				# イラストが見つからなければ例外を返す
				if @agent.page.search('span[@class=error]').length > 0 then
					raise IllustNotFoundError
				end
				
				if !Parser::Image.is_manga(@agent.page) then	# イラスト
					Presenter::Image::Illust.new(@agent, illust_id)
				else	# 漫画
					Presenter::Image::Manga.new(@agent, illust_id)
				end
			end
		end
	end
end