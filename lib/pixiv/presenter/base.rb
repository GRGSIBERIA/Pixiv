=begin
構造を表すためのベースクラス
=end

module Pixiv
	module Presenter
		class Base
			# @param [Mechanize::Page] アクセスしたページ
			def initialize(page)
				@page = page
			end
		end
	end
end