=begin
Pixiv�̃C���X�g�����܂Ƃ߂Ă������߂̃N���X
=end
require './pixiv/presenter/base.rb'

module Pixiv
	module Presenter < Base
		# �C���X�g�����i�[���邽�߂̃N���X
		class Illust
			# @return [Array<String>] �^�O���̔z��
			def tags
			
			end
			
			# @return [String] �^�C�g��
			def title
			
			end

			# @return [String] �L���v�V����
			def caption
			
			end
			
			# @return [Presenter::Author] ���[�U���
			def author
			
			end
			
			# @return [Date] ���e�������t
			def date
			
			end
			
			# @return [String] �C���X�g�̑傫��
			def size
			
			end
		end
	end
end