=begin
テーブルをまとめたもの  
=end
require './pixiv/database/db.rb'
require './pixiv/database/tables/table_base.rb'
require './pixiv/database/tables/tag_table.rb'
require './pixiv/database/tables/tags_array_table.rb'
require './pixiv/database/tables/user_info_table.rb'
require './pixiv/database/tables/illust_info_table.rb'

module Pixiv
  module Database
    module Tables
      class TableCollection
        def initialize(db)
          @db = db
          @table_base = TableBase.new(db)
          @tag_table = TagTable.new(db)
          @tags_array_table = TagsArrayTable.new(db)
          @user_info_table = UserInfoTable.new(db)
          @illust_info_table = IllustInfoTable.new(db)
        end
        
        attr_reader :table_base, :tag_table, :tags_array_table, :user_info_table, :illust_info_table
      end
    end
  end
end