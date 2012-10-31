=begin
イラストのタグから作品、キャラクター、属性タグを推測するためのクラス  
=end
require './pixiv/database/clastering/probability.rb'

module Pixiv
  module Database
    module Clastering
      class InferProbability
        # @param table_collection [Pixiv::Database::Tables::TableCollection] テーブルの塊
        def initialize(table_collection)
          @tc = table_collection
        end
        
        # @param probs [Pixiv::Database::Clastering::Probability] 計算結果
        def GuessTypes(probs)
          # タグの種類の推測を行う
          works = Hash.new
          characters = Array.new
          attributes = Hash.new
          
          # 出現数を調べる
          targeting_count = Hash.new
          probs.probability.each do |target, candidate_hash|
            candidate_hash.each do |candidate, attr|
              targeting_count[candidate] ||= 0
              targeting_count[candidate] += attr[:probability]
            end
          end
          
          # worksを記録する
          targeting_count.sort_by{|key, value| -value}.each do |key, value|
            works[:tagid] = key
            works[:count] = value
            break
          end
          
          
          
          works
        end        
        
        # @param illust_id [Int] 推測させたいイラストID
        # @return [Pixiv::Database::Clastering::Probability] 計算結果
        def InferFromIllust(illust_id)
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
            tag_counter = CountingTags(tags_by_searched, tags_by_target, target_tag) 
            
            # カウントから確率を割り出す
            probs[target_tag] = InferFromTagCount(tag_counter, limit_norm)   # タグごとの似たタグの確率
          end
          
          Probability.new(probs, page_limit)
        end
        
        # 確率をカウントから算出する
        # @param tag_counter [Hash<Int => Int>] カウントを取得したいタグ
        # @param limit_norm [Float] ページ内取得上限の逆数
        # @return [Hash<Int => Hash>] 確率とカウントを返す
        # @return [Hash<Int => Hash>] :count 出現数
        # @return [Hash<Int => Hash>] :probability 確率
        def InferFromTagCount(tag_counter, limit_norm)
          probability = Hash.new
          tag_counter.each do |tag, count|
            # なんか数値が2倍になるので半分にしてる
            probability[tag] = {:count => (count * 0.5).to_i, :probability => TanHFilter((count.to_f * limit_norm.to_f) * 0.5)}
          end
          probability
        end
        
        # フィルタ、確率から信頼性を求める
        # @param t [Float] 確率
        # @return [Float] 信頼性
        def TanHFilter(t)
          t -= 0.5
          n = 1.0 # 任意定数, tanhの曲線が中心に寄る
          (Math.tanh(t*n*Math::PI)+1)*0.5
        end
        
        # ページ単位で収集したタグの個数を調べる
        # @param tags_by_searched [Array<Hash<Int => Array<Int>>] ページ単位でまとめたタグ
        # @param tags_by_target [Array<Int>] 調べたいイラストのタグ配列
        # @param target_tag [Int] 現在、確率を求めようとしているタグ
        # @return tag_counter [Hash<Int => Int>] ページ単位でタグごとに記録したもの
        def CountingTags(tags_by_searched, tags_by_target, target_tag)
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
        
        # ページ単位で収集したタグをなんとかハッシュにまとめる
        # @param searched_tags_by_illusts [Array<Hash>] イラストから収集したタグ
        # @param searched_tags_by_illusts [Array<Hash>] :illust_id イラストID
        # @param searched_tags_by_illusts [Array<Hash>] :tagid タグID
        # @return [Hash<Int => Array<Int>>] イラストID => タグIDの配列
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