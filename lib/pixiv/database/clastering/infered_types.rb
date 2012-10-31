=begin
推測済みのタイトルタグ、キャラタグ、属性タグをまとめるクラスs  
=end

module Pixiv
  module Database
    module Clastering
      class InferedTypes
        # @param works [Hash]
        # @param characters [Hash]
        def initialize(works, characters, attributes)
          @works = works
          @characters = characters
          @attributes = attributes
        end
        
        attr_reader :works, :characters, :attributes
      end
    end
  end
end