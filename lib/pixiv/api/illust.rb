=begin
特定のイラスト情報を問い合わせるためのクラス
=end
require './pixiv/api/base.rb'
require './pixiv/presenter/illust.rb'
require 'net/http'
require 'uri'

module Pixiv
	module API
		class Illust < Base
			# @param agent [Mechanize] セッションの確立している状態のもの
			def initialize(agent)
				super(agent)
			end
		
			# あるイラスト情報のあるページをクロールしに行く
			# @param illust_id [Int] 情報を取得するイラストID
			# @return [Presenter::Image] 取得したイラスト情報
			def show(illust_id)
				uri = "http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{illust_id.to_s}"
				@agent.get(uri).body
				#File.write("test.txt", @agent.page.body)
				
				if !Parser::Illust.is_manga(@agent.page) then	# イラスト
					Presenter::Illust.new(@agent, illust_id)
				else	# 漫画
					Presenter::Manga.new(@agent, illust_id)
				end
			end
		end
	end
end