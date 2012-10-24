=begin
�C���X�g�ɕt����ꂽ�^�O���L�q���邽�߂̃e�[�u��
=end
require './pixiv/database/tables/table_base.rb'

module Pixiv
  module Database
    module Tables
      class TagsArrayTable < TableBase
        def initialize(db)
          super(db)
        end
        
        # �C���X�g����^�OID���擾����
        # @param illust_id [Int] �C���X�gID
        # @return [Int] �^�OID
        def GetTagsFromIllust(illust_id)
          sql = 'select tagid from tags_array_table where illust_id = ?'
          GetMulti(sql, [illust_id], "i")
        end
        
        # �C���X�g�̔z�񂩂�^�OID���擾����
        # @param illusts [Array<Int>] �C���X�gID�̔z��
        # @return [Int] �������傭���ɂ�����Ԃ̃^�OID�z��
        def GetTagsFromIllustArray(illusts)
          sql = 'select tagid from tags_array_table'
          GetArray(sql, illusts, "i", "illust_id")
        end
        
        # �^�OID����C���X�g�̔z����擾����
        # @param tagid [Int] �^�OID
        # @param offset [Int] �f�[�^�x�[�X��̃��R�[�h�ʒu
        # @param limit [Int] �擾�������
        # @return [Array] �������ʂƂ��ẴC���X�g
        def GetIllustsFromTagID(tagid, offset=-1, limit=-1)
          sql = 'select illust_id from tags_array_table where tagid = ?'
          sql += StringedOffsetAndLimit(offset, limit)
          GetMulti(sql, [tagid], 'i')
        end
        
        # �^�OID�̔z��
        def GetIllustsFromTagIDArray(tagids, offset=-1, limit=-1)
          sql = 'select illust_id, tagid from tags_array_table'
          GetMultiArray(sql, tagids, ["i", "i"], "illust_id", [:illust_id, :tagid])
        end
      end
    end
  end
end