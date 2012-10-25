=begin
TagTable用のクラス  
=end
require './pixiv/database/tables/table_base.rb'

module Pixiv
  module Database
    module Tables
      # タグのテーブル
      class TagTable < TableBase
        # @param db [SQLite3::Database] データベース
        def initialize(db)
          super(db)
        end
        
        # @return [Int] レコード件数
        def count
          @count ||= GetCount("tagid")
        end
        
        # @param [Int] tagid タグのID
        # @return [String] タグ名
        def GetTagNameFromTagID(tagid)
          sql = 'select name from tag_table where tagid = ? limit 1'
          GetSingle(sql, [tagid], "s")
        end
        
        # @param tagids [Array<Int>] タグのID配列
        # @param limit [Int] 上限値
        # @return [Array<String>] 文字列の配列
        def GetTagNamesFromTagIDArray(tagids, limit=-1)
          sql = 'select name from tag_table'
          GetArray(sql, tagids, "s", "tagid", limit)
        end
        
        # @param tagname [String] タグ名
        # @return [Int] タグID
        def GetTagIDFromTagName(tagname)
          sql = 'select tagid from tag_table where name = ? limit 1'
          GetSingle(sql, [tagname], "i")
        end
        
        # @param tagnames [Array<String>] タグ名の配列
        # @param limit [Int] 上限値
        # @return [Array<Int>] タグIDの配列
        def GetTagIDFromTagNameArray(tagnames, limit=-1)
          sql = 'select tagid from tag_table'
          GetArray(sql, tagnames, "s", "name", limit)
        end
        
        # @param offset [Int] 開始位置、-1で指定なし
        # @param limit [Int] 取得行数、-1で指定なし
        # @return [Array<Hash>] データの配列
        # @return [Array<Hash>] :tagid タグID
        # @return [Array<Hash>] :name タグの名前
        def GetRecords(offset=-1, limit=-1)
          sql = 'select tagid, name, from tag_table'
          sql += StringedOffsetAndLimit(offset, limit)
          result = Array.new
          @db.execute(sql) do |row|
            result << {:tagid => row[0].to_i, :name => row[1]}
          end
          result
        end
      end
    end
  end
end