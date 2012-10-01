=begin
�^�O�����W���邽�߂̏W�c�N���X
�^�O��ǉ�����ƃ^�O���Ƃ̍��v�l�����߂Ă����
=end

module Pixiv
	module Util
		module Tag
			class Constellation
				def initialize()
					@tags = Hash.new
					@counter = 0
				end
				
				# @return [Hash<Presenter::Instance::Tag => Int>] �^�O������^�O���������o��
				def tags
					@tags
				end
				
				# @return [Int] �S���œ����ꂽ�^�O�̑���
				def count
					@counter
				end
				
				# @param tag [Presenter::Instance::Tag] �^�O
				# @return Add���Ă΂ꂽ��
				def Add(tag)
					@tags[tag] ||= 0
					@tags[tag] += 1
					@counter += 1
				end
			end
		end
	end
end