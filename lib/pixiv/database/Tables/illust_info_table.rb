=begin
イラスト情報のテーブルクラス  
=end
require './pixiv/database/tables/table_base.rb'

module Pixiv
  module Database
    module Tables
      class IllustInfoTable < TableBase
        def initialize(db)
          super(db)
        end
        
        # ユーザIDからイラストを取得する
        # @param userid [Int] ユーザID
        # @return [Array<Int>] イラストIDの配列
        def GetIllustIDsFromUserID(userid)
          sql = 'select illust_id from illust_info_table where userid = ?'
          GetMulti(sql, [userid], "i")
        end
        
        # イラストIDからユーザIDを引き出す
        # @param illust_id [Int] イラストID
        # @return [Int] ユーザID
        def GetUserIDFromIllustID(illust_id)
          sql = 'select userid from illust_info_table where illust_id = ? limit 1'
          GetSingle(sql, [illust_id], "i")
        end
        
        # イラストIDからレコードを1件だけ取得する
        # @param illust_id [Int] イラストID
        # @return [Hash] レコード情報
        # @return [Hash] :illust_id イラストID
        #　@return [Hash] :userid ユーザID
        # @return [Hash] :score 評価点数
        # @return [Hash] :view 閲覧数
        # @return [Hash] :rated 評価回数
        # @return [Hash] :title タイトル
        # @return [Hash] :date 投稿日時
        # @return [Hash] :illust_type イラストか漫画か, i, m
        # @return [Hash] :r18 R18のイラストか, t, f
        def GetRecordFromIllustID(illust_id)
          sql = 'select illust_id, userid, score, view, rated, title, date, illust_type, r18 from illust_info_table'
          GetMultiArray(sql, [illust_id], 
            ["i", "i", "i", "i", "i", "s", "s", "s", "s"], "illust_id", 
            [:illust_id, :userid, :score, :view, :rated, :title, :date, :illust_type, :r18], 1)[0]
        end
        
        # イラストIDからレコードを1件だけ取得する
        # @param illust_ids [Array<Int>] イラストIDの配列
        # @return [Array<Hash>] レコード情報
        # @return [Array<Hash>] :illust_id イラストID
        #　@return [Array<Hash>] :userid ユーザID
        # @return [Array<Hash>] :score 評価点数
        # @return [Array<Hash>] :view 閲覧数
        # @return [Array<Hash>] :rated 評価回数
        # @return [Array<Hash>] :title タイトル
        # @return [Array<Hash>] :date 投稿日時
        # @return [Array<Hash>] :illust_type イラストか漫画か, i, m
        # @return [Array<Hash>] :r18 R18のイラストか, t, f
        def GetRecordFromIllustIDArray(illust_ids)
          sql = 'select illust_id, userid, score, view, rated, title, date, illust_type, r18 from illust_info_table'
          GetMultiArray(sql, illust_ids, 
            ["i", "i", "i", "i", "i", "s", "s", "s", "s"], "illust_id", 
            [:illust_id, :userid, :score, :view, :rated, :title, :date, :illust_type, :r18], illust_ids.length)
        end
        
        def GetRecordFromUserID(userid)
          sql = 'select illust_id, userid, score, view, rated, title, date, illust_type, r18 from illust_info_table'
          GetMultiArray(sql, [userid], 
            ["i", "i", "i", "i", "i", "s", "s", "s", "s"], "userid", 
            [:illust_id, :userid, :score, :view, :rated, :title, :date, :illust_type, :r18], 1)[0]
        end
        
        def GetRecordFromIllustIDArray(userids)
          sql = 'select illust_id, userid, score, view, rated, title, date, illust_type, r18 from illust_info_table'
          GetMultiArray(sql, userids, 
            ["i", "i", "i", "i", "i", "s", "s", "s", "s"], "userid", 
            [:illust_id, :userid, :score, :view, :rated, :title, :date, :illust_type, :r18], illust_ids.length)
        end
      end
    end
  end
end