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
					tags = param[:client].artist.tags(param[:id])
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
		end
	end
end