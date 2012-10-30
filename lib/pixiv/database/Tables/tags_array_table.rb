=begin
イラストに付けられたタグを記述するためのテーブル
=end
require './pixiv/database/tables/table_base.rb'

module Pixiv
  module Database
    module Tables
      class TagsArrayTable < TableBase
        def initialize(db)
          super(db)
        end
        
        # @return [Int] レコード件数
        def count
          @count ||= GetCount("illust_id")
        end
        
        # イラストからタグIDを取得する
        # @param illust_id [Int] イラストID
        # @return [Array<Int>] タグIDの配列
        def GetTagsFromIllustID(illust_id)
          sql = 'select tagid from tags_array_table where illust_id = ?'
          GetMulti(sql, [illust_id], "i")
        end
        
        # イラストの配列からタグIDを取得する
        # @param illusts [Array<Int>] イラストIDの配列
        # @return [Array<Hash>] イラストIDとタグIDの配列
        # @return [Array<Hash>] :illust_id イラストID
        # @return [Array<Hash>] :tagid タグID
        def GetTagsFromIllustIDArray(illusts)
          sql = 'select tagid, illust_id from tags_array_table'
          GetMultiArray(sql, illusts, ["i", "i"], "illust_id", [:tagid, :illust_id])
        end
        
        # タグIDからイラストの配列を取得する
        # @param tagid [Int] タグID
        # @param offset [Int] データベース上のレコード位置
        # @param limit [Int] 取得上限件数
        # @return [Array] 検索結果としてのイラスト
        def GetIllustsFromTagID(tagid, offset=-1, limit=-1)
          sql = 'select illust_id from tags_array_table where tagid = ?'
          sql += StringedOffsetAndLimit(offset, limit)
          GetMulti(sql, [tagid], 'i')
        end
        
        # タグIDの配列
        # @param tagids [Int] タグIDの配列
        # @param offset [Int] データベース上の位置
        # @param limit [Int] 取得上限件数
        # @return [Array<Hash>] イラストIDとタグIDのペア、ハッシュで管理
        # @return [Array<Hash>] :illust_id イラストID
        # @return [Array<Hash>] :tagid タグID
        def GetIllustsFromTagIDArray(tagids, offset=-1, limit=-1)
          sql = 'select illust_id, tagid from tags_array_table'
          GetMultiArray(sql, tagids, ["i", "i"], "illust_id", [:illust_id, :tagid])
        end
      end
    end
  end
end