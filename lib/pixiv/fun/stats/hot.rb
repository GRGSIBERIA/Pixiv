=begin
ホットさを調べるためのモジュール
=end

module Pixiv
	module Fun
		module Stats
			class Hot
				# タグからホットさの検索をかける
				# @param client [Pixiv::Client] クライアント
				# @param tag_name [String] 検索対象のタグ
				# @return [Float] log10した検索結果
				def self.Tag(client, tag_name)
					search_result = client.search.tag(tag_name, {:range => 1..1})
					search_result.picture_count
				end
				
				def self.TagsAverage(client, tags)
					if tags.length <= 0 then return 0.0 end
					
					result_count_arr = Array.new
					sum = 0.0
					div = 1.0 / tags.length
					
					tags.each{|tag| result_count_arr << Hot.Tag(client, tag.name)}
					result_count_arr.each{|tag_count| sum += tag_count}
					average = sum * div
				end
				
				# タグの配列からホットさを調べつつ、その分散（エントロピー）を調べる
				# @param client [Pixiv::Client] クライアント
				# @param tags [Presenter::Instance::Tags] エントロピーを求めたいタグの集合
				# @return [Float] 分散、エントロピー
				def self.TagsSpread(client, tags)
					average = Hot.TagsAverage(client, tags)
					
					spread = 0.0
					result_count_arr.each{|tag_count| spread += (tag_count - average) * (tag_count - average)}
					sqr_spread = Math::sqrt(spread * div)
				end
			end
		end
	end
end