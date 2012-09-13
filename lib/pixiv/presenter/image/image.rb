=begin
�C���X�g�▟��A�T���l�Ȃǂ̋��ʂ�����񂪓���
�C���X�g���y�[�W��image_info.rb���Q��
=end
require './pixiv/presenter/base.rb'
require './pixiv/parser/image.rb'
require './pixiv/presenter/instance/picture.rb'

module Pixiv
	module Presenter
		module Image
			class Image < Base
				# @param [Mechanize::Page] �y�[�W
				def initialize(agent, illust_id, picture_type)
					super(agent)
					@illust_id = illust_id
					@uri = agent.page.uri
					@type = picture_type
				end
				
				# �C���X�g���y�[�W��ۑ�����
				# @param directory [String] �ۑ���̃f�B���N�g��
				def save(directory)
					File.write(directory + illust_id.to_s + ".html", @page.body)
				end
				
				# @return [String] �摜�̃^�C�v
				# NOTE: 
				def type
					@type
				end
				
				# @return [String] �C���X�g���y�[�W��ID
				def uri
					@uri
				end
				
				# @return [String] �C���X�g��ID
				def illust_id
					@illust_id
				end
				
				# @return [String] �^�C�g��
				def title
					@title ||= Parser::Image.title(@page)
				end
				
				# @return [String] ���[�U��
				def artist
					@artist ||= Parser::Image.artist(@page)
				end
				
				# @return [String] ���[�UID
				def userid
					@userid ||= Parser::Image.userid(@page)
				end
				
				# @return [String] ���ۂ̉摜���u����Ă���u����Ă���URI
				# EXAMPLE:
				# 		http://i2.pixiv.net/img12/img/hoge123/
				def location
					@location ||= Parser::Image.location(@page) + "/"
				end
				
				# @return [String] �C���X�g�̊g���q
				# EXAMPLE:
				#		.jpg, .gif, .png
				def extension
					@extension ||= Parser::Image.extension(@page)
				end
				
				# @return [Presenter::Instance::Picture] �T���l�摜
				def thumbnail
					@thumbnail ||= CreatePicture("_s")
				end
				
				# @return [Presenter::Instance::Picture] �C���X�g����ʂ̉摜
				def medium
					@medium ||= CreatePicture("_m")
				end
				
				# @param [String] �C���X�gID�̌�ɕt����z
				# @return [Presenter::Instance::Picture] �摜�C���X�^���X
				def CreatePicture(prefix)
					arg = {	
						:illust_id => illust_id, 
						:location => location, 
						:referer => uri, 
						:prefix => prefix,
						:extension => extension}
					Presenter::Instance::Picture.new(@agent, arg)
				end
				protected :CreatePicture
			end
		end
	end
end