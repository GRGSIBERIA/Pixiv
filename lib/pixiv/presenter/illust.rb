=begin
Pixiv�̃C���X�g�����܂Ƃ߂Ă������߂̃N���X
=end
require './pixiv/presenter/base.rb'

module Pixiv
	module Presenter
		# �C���X�g�����i�[���邽�߂̃N���X
		class Illust < Base
			# @return [Array<String>] �^�O���̔z��
			def tags
			
			end
			
			# @return [String] �^�C�g��
			def title
			
			end

			# @return [String] �L���v�V����
			def caption
			
			end
			
			# @return [String] ���[�U��
			def username
			
			end
			
			# @return [Int] ���[�UID
			def userid
			
			end
			
			# @return [Date] ���e�������t
			def date
			
			end
			
			# @return [String] �C���X�g�̑傫��
			def size
			
			end
			
			# @return [Array<String>] �g�p�����c�[��
			def tools
			
			end
			
			# @return [Int] �C���X�g�̉{����
			def view_count
			
			end
			
			# @return [Int] �C���X�g�̕]����
			def evaluation_count
			
			end
			
			# @return [Int] �����_��
			def total_points
			
			end
		end
	end
end