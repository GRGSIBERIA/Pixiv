=begin
Pixiv�ɖ₢���킹�邽�߂�API�̃x�[�X�N���X
=end

module Pixiv
	module API
		class Base
			# @param agent [Mechanize] �Z�b�V�����̊m�����Ă����Ԃ̂���
			def initialize(agent)
				@agent = agent
			end
		end
	end
end