=begin
����̃��[�U����₢���킹�邽�߂̃N���X
=end
require './pixiv/api/base.rb'

module Pixiv
	module API
		class Artist < Base
			# @param agent [Mechanize] �Z�b�V�����̊m�����Ă����Ԃ̂���
			def initialize(agent)
				super(agent)
			end
			
			# @param userid [Int] ���[�UID
			def get(userid)
				uri = "http://www.pixiv.net/member.php?id=#{userid}"
				@agent.get(uri)
				
				# ���[�U�����݂��Ȃ���Η��Ƃ�
				if @agent.page.search('span[@class="error"]') > 0 then
					raise ArtistNotFoundError; end
				
				Presenter::Artist.new(@agent, userid)
			end
		end
	end
end