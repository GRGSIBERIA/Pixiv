=begin
�����C���X�g�Ȃǂ̏��y�[�W
=end
require './pixiv/presenter/image.rb'

module Pixiv
	module Presenter
		class ImageInfo < Image
			def initialize(agent, illust_id)
				super(agent, illust_id)
			end
			
			# @return [Array<String>] �^�O���̔z��
			def tags
				@tags ||= Parser::Image.tags(@page)
			end
			
			# @return [String] �L���v�V�����A����
			def caption
				@caption ||= Parser::Image.caption(@page)
			end
			
			# @return [String] ���e�������t
			def date
				@date ||= Parser::Image.date(@page)
			end
			
			# @return [Array<String>] �g�p�����c�[��
			def tools
				@tools ||= Parser::Image.tools(@page)
			end
			
			# @return [Int] �C���X�g�̉{����
			def view_count
				@view_count ||= Parser::Image.view_count(@page)
			end
			
			# @return [Int] �C���X�g�̕]����
			def rated_count
				@rated_count ||= Parser::Image.rated_count(@page)
			end
			
			# @return [Int] �����_��
			def score_count
				@score_count ||= Parser::Image.score_count(@page)
			end
		end
	end
end