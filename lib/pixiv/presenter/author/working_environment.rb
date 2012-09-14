=begin
投稿者の作業環境
=end
require './pixiv/presenter/author/artist.rb'

module Pixiv
	module Presenter
		module Author
			class WorkingEnvironment < Artist
				# @param agent [Mechanize] セッションを確立したインスタンス
				def initialize(agent)
					super(agent)
				end
				
				
			end
		end
	end
end