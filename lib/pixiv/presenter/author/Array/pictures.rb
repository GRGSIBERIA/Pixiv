=begin
���[�U�����e�����T���l�p�̉摜���܂Ƃ߂�����
=end
require './pixiv/presenter/author/array/base.rb'

module Pixiv
	module Presenter
		module Author
			module Array
				class Pictures < Array::Base
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