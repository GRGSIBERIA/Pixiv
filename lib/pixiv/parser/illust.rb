=begin
イラストページから情報を取得してくるクラスメソッド
=end

module Pixiv
	module Parser
		class Illust
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] タイトル
			def Parser.title(page)
				page.at("h1[@class=title]").inner_text
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @param [String] イラストの概要
			def Parser.caption(page)
				path = 'div[@id="caption_long"]'
				@agent.page.at(path).inner_text
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @param [Array<String>] タグの配列
			def Parser.tags(page)
				path = 'span[@id=tags]/a'
				
				# 拾ってきたタグの中から意味のないタグを排除する
				all_tags = @agent.page.search(path)
				tags = Array.new
				for i in 0..all_tags.length-1 do
					all_tags[i].each{|k,v| 
						if v.include?("tags.php") then # tags.phpの入っていないリンクは除去
							tags << all_tags[i].inner_text 
						end
					}
				end
				tags
			end
		end
	end
end