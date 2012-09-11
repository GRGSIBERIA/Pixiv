=begin
イラストページから情報を取得してくるクラスメソッド
=end

module Pixiv
	module Parser
		class Illust
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] タイトル
			def self.title(page)
				page.at("h1[@class='title']").inner_text
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] イラストの概要
			def self.caption(page)
				path = 'div[@id="caption_long"]'
				page.at(path).inner_text
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [Array<String>] タグの配列
			def self.tags(page)
				path = 'span[@id=tags]/a'
				
				# 拾ってきたタグの中から意味のないタグを排除する
				all_tags = page.search(path)
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
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] 投稿者の名前
			def self.artist(page)
				path = 'a[@class=avater_m]'
				page.at(path)['title']
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @param [String] 投稿者のID
			def self.userid(page)
				path = 'a[@class=avater_m]'
				page.at(path)['href'].delete('/member.php?id=')
			end
		end
	end
end