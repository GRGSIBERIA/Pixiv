=begin
イラストのタグから作品、キャラクター、属性タグを推測するためのクラス  
=end

module Pixiv
  module Database
    module Clastering
      class GuessTagType
        # @param table_collection [Pixiv::Database::Tables::TableCollection] テーブルの塊
        def initialize(table_collection)
          @tc = table_collection
        end
        
        # @param illust_id [Int] 推測させたいイラストID
        # @return [Array<Hash>] タグごとの作品やキャラクターなどの推測
        # @return [Array<Hash>] :tagid タグID
        # @return [Array<Hash>] :tagname タグの名前
        # @return [Array<Hash>] :type :work, :character, :property
        def GuessType(illust_id)
          page_limit = 5  # 1ページに存在するイラストの数
          limit_norm = 1.0 / page_limit.to_f
          probs = Hash.new
          
          # イラストに付けられたタグを調べる
          tags_by_target = @tc.tags_array_table.GetTagsFromIllustID(illust_id)
          
          # タグからイラストを検索する
          for target_tag in tags_by_target do
            # TagIDArrayで検索しないのは検索数上限の設定がタグごとにできないから
            # タグ→イラストで検索されたものをページと呼ぶことにする
            searched_tag = @tc.tags_array_table.GetIllustsFromTagID(target_tag, -1, page_limit)
            
            # タグから検索できたイラストのタグを一斉に検索する
            will_search_illust = Array.new
            searched_tag.each do |elem|
              will_search_illust << elem[:illust_id]
            end
            searched_tags_by_illusts = @tc.tags_array_table.GetTagsFromIllustIDArray(will_search_illust)
            
            # イラストごとのタグをハッシュにまとめる
            tags_by_searched = Hash.new
            searched_tags_by_illusts.each do |record|
              tags_by_searched[record[:illust_id]] ||= Array.new
              tags_by_searched[record[:illust_id]] << record[:tagid]
            end
            
            # ページ単位で残ったタグを調べる
            probs_buffer_from_page = Array.new
            tags_by_searched.each do |illust, tags|
              tag_counter = Hash.new  # 見つかったタグを調べていく
              target_tag.each do |counting_tag|
                # 対象のタグが検索イラストのタグの中に見つかればカウントする
                if tags.include?(counting_tag) and counting_tag != target_tag then
                  tag_counter[counting_tag] ||= 0
                  tag_counter[counting_tag] += 1
                end
              end
              
              # カウントを確率に戻す
              tag_counter.each do |tag, count|
                tag_counter[tag] = count.to_f * limit_norm.to_f # イラストごとのタグの確率を求める
              end
              probs_buffer_from_page << tag_counter
              # ---ここまでがページ単位---
            end
            
            probs[target_tag] = probs_buffer_from_page  # ページ単位の確率をまとめる
          end
          # @return probs 対象タグごとにページ単位で検索されたイラストの対象タグが含まれている確率が入ってる
          
          # probsでタグ->ページ->イラストの確率を求めた
          # ページごとの確率にまとめる
        end
      end
    end
  end
end