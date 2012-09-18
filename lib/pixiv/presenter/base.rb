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
				#@size = agent.page.body.length
				#@body = agent.page.body
			end
			
			# @return 取得したページの容量
			def size
				@size
			end
			
			# @return ページの本体
			def body
				@body
			end
		end
	end
end