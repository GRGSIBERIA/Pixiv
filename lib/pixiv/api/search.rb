=begin
検索用のAPI。
主に検索フォームからタグやキーワードを入力する場合を想定。
=end
require './pixiv/api/base.rb'

module Pixiv
	module API
		class Search < Base
			def initialize(agent)
				super(agent)
			end
		end
	end
end