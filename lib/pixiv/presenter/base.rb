=begin
構造を表すためのベースクラス
=end
require 'mechanize'

module Pixiv
	module Presenter
		class Base
			# @param [Mechanize::Page] アクセスしたページ
			def initialize(agent)
				@agent = agent
				@page = agent.page
				@size = agent.page.body.length
			end
			
			# @return 取得したページの容量
			def size
				@size
			end
		end
	end
end