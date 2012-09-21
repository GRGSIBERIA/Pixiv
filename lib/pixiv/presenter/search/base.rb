=begin
����API�p�\���̂̃x�[�X�N���X
=end
require './pixiv/parser/listing.rb'

module Pixiv
	module Presenter
		module Search
			class Base
				def initialize(agent, words, param)
					@agent = agent
					@param = param
					@words = words
					@listing = Perser::Listing.new(agent)
				end
				
				# @return [Presenter::Image::Thumbnail] �����Ŏ擾�ł����T���l
				def pictures
					@listing.GetThumbnail(@param)
				end
				
				# @return [Int] �����Ɉ������������摜�̌���
				def picture_count
					@picture_count ||= GetPictureCount()
				end
				
				# @return [Int] ���y�[�W���݂��邩
				def max_count
					@max_count ||= GetMaxPageNum()
				end
				
				# @return [Int] �������ʂɑ΂���y�[�W��
				def GetMaxPageNum()
					@max_count = picture_count.div(20) + 1
				end
				private :GetMaxPageNum
				
				# @return [Int] �����Ɉ������������摜�̌���
				def GetPictureCount()
					@agent.get(@param[:uri])	# ��x�ŏ��̃y�[�W���擾���čő�y�[�W�����擾���Ă���
					max_page_text = @agent.page.at(@param[:picture_count]).inner_text
					max_page_text.scan(/[0-9]+/)[0].to_i
				end
				private :GetPictureCount
				
				# param����l�X�ȃp�����[�^��؂�o����URI�𐶐�����
				# @return [String] �p�����[�^�t����URI
				def MakeURI(words, mode)
					uri = 'http://www.pixiv.net/'
					
					case mode
					when "keyword" then 
						uri += 'search.php?'
					when "tag" then 
						uri += 'tags.php?'
					end
					
					uri += MergeKeywords(words, @param[:include], @param[:exclude])
					uri += MakeSinceDate(@param[:since_date])
					uri += MakePartialMatch(mode, @param[:partial_match])
					uri += MakeOrder(@param[:order])
					uri += MakePictureSizeRange(@param[:size])
					uri += MakeAspectRatio(@param[:ratio])
					uri += MakeTool(@param[:tool])
				end
				protected :MakeURI
				
				# �c�[�������G���R�[�h���邾��
				def MakeTool(tool)
					if tool != nil then
						'&tool=' + CGI.escape(tool.toutf8)
					else
						""
					end
				end
				private :MakeTool
				
				# �����𐶐�����
				def MakeSinceDate(since_date)
					if since_date != nil then
						if since_date.class == Date then
							'&scd=' + since_date.strftime("%Y-%m-%d")
						else
							raise ArgumentError, "since_day��Date�^�ɂ��Ă�������"
						end
					else
						""
					end
				end
				private :MakeSinceDate
				
				# ���я��𐶐�����Aorder�ɉ��������Ă�Ɖߋ���
				def MakeOrder(order)
					if order != nil then
						"&order=date"
					else
						""
					end
				end
				private :MakeOrder
				
				# ������v�Ɗ��S��v�̔���
				def MakePartialMatch(mode, partial_match)
					case mode
					when "keyword" then
						# �L�[���[�h�̏ꍇ�͊��S��v�����݂��Ȃ�
						'&s_mode=s_tc'
					when "tag" then
						# ������v�̏ꍇ�̂ݕt����
						partial_match != nil ? '&s_mode=s_tag' : ""
					else
						""
					end
				end
				private :MakePartialMatch
				
				# �A�X�y�N�g��̐ݒ�
				def MakeAspectRatio(ratio)
					if ratio != nil then
						if ratio.class == String then
							case ratio
							when "horizontal"	# ����
								ratio = "0.5"
							when "vertical"	# �c��
								ratio = "-0.5"
							when "rectangle" # �����`
								ratio = "0"
							end
						elsif ratio.class != Float then
							ratio = ratio.to_s
						else
							raise ArgumentError, "�^����������:" + ratio.class
						end
						"&ratio=" + ratio
					else
						""
					end
				end
				private :MakeAspectRatio
				
				# �摜�̑傫�����w�肵�Ă��͈̔͂̉摜���擾����
				# ngt��n�ȉ��Anlt��n�ȏ�̈Ӗ�
				def MakePictureSizeRange(size)
					if size != nil then
						wgt = nil; hgt = nil; wlt = nil; hlt = nil

						if size.class == String then
							# �摜�̃T�C�Y�𕶎���Ŏw��
							case size
							when "small" then
								wgt = 1000
								hgt = 1000
							when "middle" then
								wgt = 3000
								hgt = 3000
								wlt = 1001
								hlt = 1001
							when "large" then
								wlt = 3001
								hlt = 3001
							else
								raise ArgumentError, "small, middle, large�̂ǂꂩ���w�肵�Ă�������"
							end
						elsif size.class == Hash then
							# ���l�Œ��ڎw��
							wgt = size[:wgt]
							hgt = size[:hgt]
							wlt = size[:wlt]
							hlt = size[:hlt]
						end
						
						parameters = ""	# �Ȃ��z�͖�������
						if wgt != nil then parameters += '&wgt=' + wgt.to_s; end;
						if hgt != nil then parameters += '&hgt=' + hgt.to_s; end;
						if wlt != nil then parameters += '&wlt=' + wlt.to_s; end;
						if hlt != nil then parameters += '&hlt=' + hlt.to_s; end;
						parameters
					else
						""
					end
				end
				private :MakePictureSizeRange
				
				# �L�[���[�h���������ăG���R�[�h����
				# @param words [Array<String>] �L�[���[�h
				# @param include [Array<String>] �����ꂩ�̃L�[���[�h���܂�
				# @param exclude [Array<String>] ���O����L�[���[�h
				# @return [String] URI�G���R�[�h�ς݃p�����[�^
				def MergeKeywords(words, include, exclude)
					merged_words = ""
					if words.class == Array then
						words.each{|w| merged_words += w + " "}
						merged_words.strip!
					elsif words.class == String then
						merged_words = words
					end
					
					# �`���܂ޕ�����
					if include != nil then
						if include.class != Array then raise ArgumentError, "include��Array�^����Ȃ�"; end
						merged_words += " ("
						include.each{|w| merged_words += w + " OR "}
						merged_words.sub(/( OR )$/, "")
						merged_words += ")"
					end
					
					# ���O������������
					if exclude != nil then
						if exclude.class != Array then raise ArgumentError, "exclude��Array�^����Ȃ�"; end
						merged_words += " "
						exclude.each{|w| merged_words += " -" + w}
					end
					
					"&word=" + CGI.escape(merged_words.toutf8)
				end
				private :MergeKeywords
			end
		end
	end
end