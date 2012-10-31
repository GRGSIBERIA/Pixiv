=begin
GuessTagTypeクラスで計算した結果を入れるためのクラス  
=end

module Pixiv
  module Database
    module Clastering
      class Probability
        # @param probs [Hash<Int => Hash<Int => Hash>>] 対象のタグ => ページ内イラスト => カウントと確率など
        # @param probs [Hash<Int => Hash<Int => Hash>>] :count 個数
        # @param probs [Hash<Int => Hash<Int => Hash>>] :probability 予測コスト
        # @param limit [Int] ページ内イラスト件数
        def initialize(probs, limit)
          @probability = probs
          @limit_in_page = limit
        end
        
        attr_reader :probability, :limit_in_page
      end
    end
  end
end