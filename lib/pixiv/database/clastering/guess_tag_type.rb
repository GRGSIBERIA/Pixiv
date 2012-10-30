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
            searched_tags_by_illusts = @tc.tags_array_table.GetTagsFromIllustIDArray(searched_tag)
            
            # イラストごとのタグをハッシュにまとめる
            tags_by_searched = CollectPageToArrayHash(searched_tags_by_illusts)
            
            # ページ単位で残ったタグを調べる
            tag_counter = Hash.new  # 見つかったタグを調べていく
            tags_by_searched.each do |illust, tags|
              tags_by_target.each do |counting_tag|
                # 対象のタグが検索イラストのタグの中に見つかればカウントする
                if tags.include?(counting_tag) and counting_tag != target_tag then
                  tag_counter[counting_tag] ||= 0
                  tag_counter[counting_tag] += 1
                end
              end
            end
            
            # カウントを確率に戻す
            tag_counter.each do |tag, count|
              tag_counter[tag] = count.to_f * limit_norm.to_f # イラストごとのタグの確率を求める
            end
            probs[target_tag] = tag_counter # タグごとの似たタグの確率
          end
          
          # probs => Hash<Int => Hash<Int => Float>>
          # probs => Hash<tagid => Hash<tagid => probability>>
          # {A => {B => 0.8, C => 0.6}, B => {A => 1.0}}
          probs
        end
        
        def CountingTags(tags_by_searched)
          tag_counter = Hash.new  # 見つかったタグを調べていく
          tags_by_searched.each do |illust, tags|
            tags_by_target.each do |counting_tag|
              # 対象のタグが検索イラストのタグの中に見つかればカウントする
              if tags.include?(counting_tag) and counting_tag != target_tag then
                tag_counter[counting_tag] ||= 0
                tag_counter[counting_tag] += 1
              end
            end
          end
          tag_counter
        end
        
        # イラストから収集したタグをなんとかハッシュにまとめる
        # @param searched_tags_by_illusts [Array<Hash>] イラストから収集したタグ
        # @param searched_tags_by_illusts [Array<Hash>] :illust_id イラストID
        # @param searched_tags_by_illusts [Array<Hash>] :tagid タグID
        # @return [Hash<Int => Int>] イラストID => タグID
        def CollectPageToArrayHash(searched_tags_by_illusts)
          tags_by_searched = Hash.new
          searched_tags_by_illusts.each do |record|
            tags_by_searched[record[:illust_id]] ||= Array.new
            tags_by_searched[record[:illust_id]] << record[:tagid]
          end
          tags_by_searched
        end
      end
    end
  end
end