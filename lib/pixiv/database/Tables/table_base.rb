=begin
テーブル用クラスのベースクラス  
=end

module Pixiv
  module Database
    module Tables
      class TableBase
        def initialize(db)
          @db = db
        end
        
        # 単一のデータを検索する
        # @param sql [String] SQL文
        # @param args [Array] 引数として渡したい配列
        # @param type [String] 取得するデータの種類
        def GetSingle(sql, args, type)
          result = nil
          @db.execute(sql, args) do |row|
            case type
            when "i" then
              result = row[0].to_i
            when "s" then
              result = row[0]
            end
          end
          result
        end
        
        # 一つの検索条件から複数の検索結果を得たいときに利用
        # @param sql [String] SQL文, where句などは入れない
        # @param args [Array] 引数として渡したい配列
        # @param type [String] 取得するデータの種類
        # @return [Array] 複数の検索結果
        def GetMulti(sql, args, type)
          ExecuteArray(sql, args, type)
        end
        
        # 複数の検索条件から複数の結果を得る
        def GetMultiArray(sql, args, types, field_name, field_hash)
          sql += MakeWhereOr(args, field_name)
          result = Array.new
          @db.execute(sql, args) do |row|
            buffer = Hash.new
            for i in 0..field_hash.length-1 do
              case types[i]
              when "i"
                buffer[field_hash[i]] = row[i].to_i
              when "s"
                buffer[field_hash[i]] = row[i]
              end
            end
            result << buffer
          end
          result
        end
        
        # 複数のデータを検索したいときに利用
        # @param sql [String] SQL文, where句などは入れない
        # @param args [Array] 引数として渡したい配列
        # @param type [String] 取得するデータの種類
        # @param field_name [String] where句で検索させたいフィールド名
        # @return [Array] field_nameで指定したフィールドの値を配列で
        def GetArray(sql, args, type, field_name, limit=-1)
          sql += MakeWhereOr(args, field_name)
          sql += CheckLimit(sql)
          ExecuteArray(sql, args, type)
        end
        
        # Limit句が存在するかどうか調べる
        # @param sql [String] SQL文
        # @return [String] ない場合はLimit句をつける、あったら空文字にする
        def CheckLimit(sql)
          if sql.include?("limit") then
            return limit > 0 ? ' limit ' + limit.to_s : ' limit ' + args.length.to_s
          end
          ""
        end
        
        # 複数検索条件をORで繋いだ文を返す
        # @param args [Array] 引数
        # @param field_name [String] フィールド名
        # @return [String] orでつないだwhere句を返す
        def MakeWhereOr(args, field_name)
          result = ""
          if args.length > 0 then
            result += ' where ' + field_name + ' = ?'
            for i in 1..args.length-1 do
              result += ' or ' + field_name + ' = ?'
            end
          end
          result
        end
        
        # offsetとlimitの値からSQL文に付加するための文字列を生成する
        # @param offset [Int] 0以下ならつけない
        # @param limit [Int] 0以下ならつけない
        # @return [String] offset, limit句を付けた文字列
        def StringedOffsetAndLimit(offset, limit)
          result = ""
          if limit > 0 then 
            result += ' limit ' + limit
          end
          if offset > 0 then
            result += ' offset ' + offset
          end
          result
        end
        
        # SQLを実行して結果を配列として得るための関数
        # @param sql [String] 実行したいSQL文
        # @param args [Array] 渡したい引数
        # @param type [String] 取得するデータの型
        # @return [Array] 取得したデータの配列
        def ExecuteArray(sql, args, type)
          result = Array.new
          case type
          when "i" then
            @db.execute(sql, args) do |row|
              result << row[0].to_i
            end
          when "s" then
            @db.execute(sql, args) do |row|
              result << row[0]
            end
          end
          result
        end
      end
    end
  end
end