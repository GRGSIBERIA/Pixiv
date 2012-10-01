=begin
�^�O�֘A�֗̕����\�b�h�W
=end
require './pixiv/presenter/instance/tag.rb'
require './pixiv/util/tag/cluster.rb'

module Pixiv
	module Util
		module Tag
			# �^�O���K�w���Ƃɔz��ɂ܂Ƃ߂�
			# :client��:id��������:tags�̂����ꂩ���K�{
			# @param param [Hash]
			# @param param [Pixiv::Client] :client �N���C�A���g
			# @param param [Int] :userid �擾������ID
			# @param param [Array<Presenter::Instance::Tag>] :tags �܂Ƃ߂����^�O�z��
			# @return [Util::Tag::Cluster] �K�w���Ƃɂ܂Ƃ߂�ꂽ�^�O
			def Clustering(param={})
				cluster = nil
				if param[:tags] != nil then
					cluster = Util::Tag.ClusteringTags(param[:tags], param)
				else
					tags = param[:client].artist.tags(param[:userid])
					tags.sort{|a, b| a.count <=> b.count}
					cluster = Util::Tag.ClusteringTags(tags, param)
				end
				cluster
			end
			module_function :Clustering
			
			# �^�O���܂Ƃ߂�, param���Ȃ��o�[�W����
			# @param tags [Array<Presenter::Instance::Tag>] �܂Ƃ߂����^�O�z��
			# @return [Util::Tag::Cluster] �K�w���Ƃɂ܂Ƃ߂�ꂽ�^�O
			def ClusteringTags(tags, param={})
				tag_cluster = nil
				if tags.length > 0 then
					tag_cluster = Array.new(tags[0].count)
					for i in 0..tag_cluster.length-1 do tag_cluster[i] = Array.new; end
					tags.each{|tag| tag_cluster[tag.count-1] << tag}
				end
				Util::Tag::Cluster.new(tag_cluster, param)
			end
			module_function :ClusteringTags
			
			def TagDistanceFromCluster(source, dest, source_tag, param={})
				# ����^�O�l�ȉ��͖���
				param[:skip_magnitude] ||= 0.0
				smag = source.magnitude(source_tag.count-1)
				if smag < param[:skip_magnitude] then return 1; end
				
				# ����^�O�K�w��菬�����ꍇ�͖���
				param[:skip_tag_number] ||= 1
				if dest.max < param[:skip_tag_number] then return 1; end
				
				dtag = dest.tag_by_name[source_tag.name]
				if dtag == nil then return 1; end	# ������Ȃ��ꍇ�͋����ő�
				
				# ���������߂Ă���̂ŒZ���قǗގ��x������
				distance = (smag - dest.magnitude(dtag.count-1)).abs
			end
			module_function :TagDistanceFromCluster
			
			# �N���X�^�[�Ԃ̗ގ��x���Z�o����
			# @param source [Util::Tag::Cluster] A
			# @param dest [Util::Tag::Cluster] B
			# @param param [Hash]
			# @param param [Float] :skip_magnitude ���̒l�ȉ��̃^�O�l�𖳎�����
			# @param param [Int] :skip_tag_number ���̒l�ȉ������^�O�������Ă��Ȃ��l�𖳎�����
			# @return [Float] �^�O�Ԃ̗ގ��x�A���ςŏo���Ă�
			def ClusterSimilarity(source, dest, param={})
				tags_similarities = Array.new
				for slines in source.tags do
					for stag in slines do
						tags_similarities << TagDistanceFromCluster(source, dest, stag, param)
					end
				end
				
				# �������قǗǂ������̂ō����قǗǂ��ق��ɒ����Ă�
				sum = 0.0
				tags_similarities.each{|s| sum += s}
				1.0 - (sum / tags_similarities.length)
			end
			module_function :ClusterSimilarity
		end
	end
end