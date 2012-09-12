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
			end
		end
	end
end