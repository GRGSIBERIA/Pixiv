=begin
Pixivに問い合わせるためのAPIのベースクラス
=end
require './pixiv/error.rb'

module Pixiv
	module API
		class Base
			# @param agent [Mechanize] セッションの確立している状態のもの
			def initialize(agent)
				@agent = agent
			end
		end
	end
end