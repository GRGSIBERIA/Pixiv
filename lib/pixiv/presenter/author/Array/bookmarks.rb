=begin
�u�b�N�}�[�N�y�[�W����擾�����T���l�����Ă������߂̃N���X
=end

module Pixiv
	module Presenter
		module Author
			module Array
				class Bookmarks < Array::Base
					def initialize(agent, param)
						# ���e���ꂽ�C���X�g���擾����
						# @param userid [Int] ���[�UID
						# @param param [Hash]
						# @param param [Range] :range �\�����������y�[�W�͈�
						def initialize(agent, param={})
							super(agent, param)
						end
					end
				end
			end
		end
	end
end