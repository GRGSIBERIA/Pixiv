=begin
����̃C���X�g����₢���킹�邽�߂̃N���X
=end
require './pixiv/api/base.rb'
require './pixiv/presenter/illust.rb'

module Pixiv
	module API
		class Illust < Base
			# @param agent [Mechanize] �Z�b�V�����̊m�����Ă����Ԃ̂���
			def initialize(agent)
				super(agent)
			end
		
			# @param illust_id [Int] �����擾����C���X�gID
			# @return [Presenter::Image => Presenter::Illust || Presenter::Manga] �擾�����C���X�g���
			def show(illust_id)
				uri = "http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{illust_id.to_s}"
				@agent.get(uri).body
				#File.write("test.txt", @agent.page.body)
				
				if !Parser::Illust.is_manga(@agent.page) then	# �C���X�g
					Presenter::Illust.new(@agent.page, illust_id)
				else	# ����
					Presenter::Manga.new(@agent.page, illust_id)
				end
			end
		end
	end
end