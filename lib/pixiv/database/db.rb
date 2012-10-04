
require 'sqlite3'

module Pixiv
	module Database
		class DB
			def initialize()
				@db = SQLite3::Database.new('pixiv.db')
				CheckTagTable()
				CheckToolTable()
				CheckIllustInfoTable()
				CheckUserInfoTable()
				CheckIllustTagsArrayTable()
				CheckBookmarkUserTable()
				CheckBookmarkIllustTable()
				CheckToolsArrayTable()
				
				CheckBookmarkIllustTagsArrayTable()
				CheckBookmarkUserTagsArrayTable()
			end
			
			def ExecuteAllTable(sql)
			  @db.execute(sql + "tag_table;")
        @db.execute(sql + "tool_table;")
        @db.execute(sql + "illust_info_table;")
        @db.execute(sql + "user_info_table;")
        @db.execute(sql + "illust_tags_array_table;")
        @db.execute(sql + "bookmark_user_table;")
        @db.execute(sql + "bookmark_illust_table;")
        @db.execute(sql + "tools_array_table;")
        @db.execute(sql + "bookmark_illust_tags_array_table;")
        @db.execute(sql + "bookmark_user_tags_array_table;")
        @db.execute(sql + "illust_response_table;")
			end
			
			# データベースの中身をクリアにする
			def clear
			  ExecuteAllTable('delete from ')
			end
			
			# データベースを全て削除する
			def drop
			  ExecuteAllTable('drop table ')
			end
			
			# データベースを閉じる
			def close
			  @db.close
			end
			
			# テーブルの存在確認
			# @param table_name [String] 確認したいテーブル名
			# @return [Bool] true or false
			def ExistTable(table_name)
			  count = 0
			  exist = "select count(*) from sqlite_master where type='table' and name='#{table_name}';"
			  @db.execute(exist) do |row|
			    count = row.join('\t')
			  end
			  count.to_i == 1 ? true : false
			end
			
			def CheckIllustResponseTable()
			  if !ExistTable("illust_response_table")
			    @db.execute("create table illust_response_table ()")
			  end
			end
			
			# tag_tableの有無チェック
			def CheckTagTable()
			  if !ExistTable("tag_table") then
			    @db.execute("create table tag_table (tagid integer primary key, name text);")
			  end
			end
			
			# tool_tableの有無チェック
			def CheckToolTable()
			  if !ExistTable("tool_table") then
			    @db.execute("create table tool_table (tool_id integer primary key, name text);")
			  end
			end
			
			# illust_info_tableの有無チェック
			def CheckIllustInfoTable()
			  if !ExistTable("illust_info_table") then
			    sql = <<EOS
create table illust_info_table (
illust_id integer primary key, response_count integer,
userid text, score integer, view integer, rated integer,
title text, caption text, tags_array integer, favorited_count integer,
date text, tools_array_id integer, illust_type integer,
r18 integer, size text);
EOS
			    @db.execute(sql)
			  end
			end
			
			# ユーザ情報テーブルの有無チェック
			def CheckUserInfoTable()
			  if !ExistTable("user_info_table") then
			    @db.execute("create table user_info_table (userid integer primary key, name text, nickname text, profile text, location text);")
			  end
			end
			
			def CheckIllustTagsArrayTable()
			  if !ExistTable("illust_tags_array_table") then
			    @db.execute("create table illust_tags_array_table (userid integer, tagid integer);")
			  end
			end
			
			def CheckBookmarkUserTable()
			  if !ExistTable("bookmark_user_table") then
			    @db.execute("create table bookmark_user_table (userid integer, bookmark_userid integer);")
			  end
			end
			
			def CheckBookmarkIllustTable()
			  if !ExistTable("bookmark_illust_table") then
          @db.execute("create table bookmark_illust_table (userid integer, bookmark_illust_id integer);")
        end
      end
      
      def CheckToolsArrayTable()
        if !ExistTable("tools_array_table") then
          @db.execute("create table tools_array_table (illust_id integer primary key, tool_id integer);")
        end
      end
      
      def CheckBookmarkIllustTagsArrayTable()
        if !ExistTable("bookmark_illust_tags_array_table") then
          @db.execute("create table bookmark_illust_tags_array_table (userid integer, tagid integer, stratum integer);")
        end
      end
      
      def CheckBookmarkUserTagsArrayTable()
        if !ExistTable("bookmark_user_tags_array_table") then
          @db.execute("create table bookmark_user_tags_array_table (userid integer, tagid integer, stratum integer);")
        end
      end
		end
	end
end