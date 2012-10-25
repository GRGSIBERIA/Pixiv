=begin
イラスト情報のテーブルクラス  
=end

module Pixiv
  module Database
    module Tables
      class IllustInfoTable
        def initialize(db)
          super(db)
        end
        
        def GetIllustIDsFromUserID(userid)
          sql = 'select illust_id from illust_info_table where userid = ?'
          GetMulti(sql, [userid], "i")
        end
      end
    end
  end
end