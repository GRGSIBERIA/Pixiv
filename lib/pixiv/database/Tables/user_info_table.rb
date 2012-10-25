=begin
ユーザ情報テーブルのデータを参照するためのクラス  
=end
require './pixiv/database/tables/table_base.rb'

module Pixiv
  module Database
    module Tables
      class UserInfoTable < TableBase
        def initialize(db)
          super(db)
        end
        
        # @return [Int] レコード件数
        def count
          @count ||= GetCount("userid")
        end
        
        # ユーザIDからニックネームを取得する
        # @param userid [Int] ユーザID
        # @return [String] ニックネーム
        def GetNicknameFromUserID(userid)
          sql = 'select nickname from user_info_table where userid = ? limit 1'
          GetSingle(sql, [userid], "s")
        end
        
        # ニックネームからユーザIDを取得する
        # @param nickname [String] ニックネーム
        # @return [Int] ユーザID
        def GetUserIDFromNickname(nickname)
          sql = 'select userid from user_info_table where nickname = ? limit 1'
          GetSingle(sql, [nickname], "i")
        end
        
        # ユーザIDとニックネームの対応付けがされたハッシュ配列を取得
        # @param userids [Array<Int>] 取得したいユーザIDの配列
        # @return [Array<Hash>] 検索結果のハッシュ配列
        # @return [Array<Hash>] :userid ユーザID
        # @return [Array<Hash>] :nickname ニックネーム
        def GetNicknamesFromUserIDArray(userids, limit=-1)
          sql = 'select userid, nickname from user_info_table'
          GetMultiArray(sql, userids, ["i", "s"], 'userid', [:userid, :nickname], limit)
        end
      end
    end
  end
end