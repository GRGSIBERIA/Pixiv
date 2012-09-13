=begin
特定のユーザ情報を問い合わせるためのクラス
=end
require './pixiv/api/base.rb'

module Pixiv
	module API
		class Artist < Base
			# @param agent [Mechanize] セッションの確立している状態のもの
			def initialize(agent)
				super(agent)
			end
			
			# @param userid [Int] ユーザID
			def get(userid)
				uri = "http://www.pixiv.net/member.php?id=#{userid}"
				@agent.get(uri)
				
				# ユーザが存在しなければ落とす
				if @agent.page.search('span[@class="error"]') > 0 then
					raise ArtistNotFoundError; end
				
				Presenter::Artist.new(@agent, userid)
			end
		end
	end
end