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
      end
    end
  end
end