=begin
�C���X�g�▟��ȂǁA������x���ʂ�����񂪓���
=end
require './pixiv/presenter/base.rb'
require './pixiv/parser/illust.rb'

module Pixiv
	module Presenter
		class Image < Base
			# @param [Mechanize::Page] �y�[�W
			def initialize(agent, illust_id)
				super(agent)
				@illust_id = illust_id
				@uri = agent.page.uri
			end
			
			def uri
				@uri
			end
			
			# @return [String] �C���X�g��ID
			def illust_id
				@illust_id
			end
			
			# @return [Array<String>] �^�O���̔z��
			def tags
				@tags ||= Parser::Illust.tags(@page)
			end
			
			# @return [String] �^�C�g��
			def title
				@title ||= Parser::Illust.title(@page)
			end

			# @return [String] �L���v�V����
			def caption
				@caption ||= Parser::Illust.caption(@page)
			end
			
			# @return [String] ���[�U��
			def artist
				@artist ||= Parser::Illust.artist(@page)
			end
			
			# @return [String] ���[�UID
			def userid
				@userid ||= Parser::Illust.userid(@page)
			end
			
			# @return [String] ���e�������t
			def date
				@date ||= Parser::Illust.date(@page)
			end
			
			# @return [Array<String>] �g�p�����c�[��
			def tools
				@tools ||= Parser::Illust.tools(@page)
			end
			
			# @return [Int] �C���X�g�̉{����
			def view_count
				@view_count ||= Parser::Illust.view_count(@page)
			end
			
			# @return [Int] �C���X�g�̕]����
			def rated_count
				@rated_count ||= Parser::Illust.rated_count(@page)
			end
			
			# @return [Int] �����_��
			def score_count
				@score_count ||= Parser::Illust.score_count(@page)
			end
			
			# @return [String] ���ۂ̉摜���u����Ă���u����Ă���URI
			# EXAMPLE:
			# 		http://i2.pixiv.net/img12/img/hoge123/
			def location
				@location ||= Parser::Illust.location(@page) + "/"
			end
			
			# @return [String] �C���X�g�̊g���q
			# EXAMPLE:
			#		.jpg, .gif, .png
			def extension
				@extension ||= Parser::Illust.extension(@page)
			end
			
			# @return [String] �T���l�摜��URI
			def thumbnail_uri
				@thumbnail_uri ||= AppendedPrefixURI('_s')
			end
			
			# @return [String] �C���X�g���ɂ���摜��URI
			def medium_uri
				@medium_uri ||= AppendedPrefixURI('_m')
			end
			
			# @return [Array<Byte>] �T���l�C���摜�̃o�C�i��
			def thumbnail
				@thumbnail ||= @agent.get(thumbnail_uri, nil, uri).body
			end
			
			# @return [Array<Byte>] �C���X�g���y�[�W�̃o�C�i��
			def medium
				@medium ||= @agent.get(medium_uri, nil, uri).body
			end
			
			# @return [String] �T���l�̃t�@�C�������擾����
			def thumbnail_filename
				@thumbnail_fillename ||= File.basename(thumbnail_uri)
			end
			
			# @return [String] �����炢�̉摜�̃t�@�C�������擾����
			def medium_filename
				@medium_filename ||= File.basename(medium_uri)
			end
			
			# @param [String] �C���X�gID�̌�ɂ��������ʎq�I�Ȃ���
			# @return [String] ���S�ȉ摜��URI
			def AppendedPrefixURI(pref)
				 location + illust_id .to_s+ pref + extension
			end
			private :AppendedPrefixURI
		end
	end
end