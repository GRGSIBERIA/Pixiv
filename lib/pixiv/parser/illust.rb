=begin
イラストページから情報を取得してくるクラスメソッド
=end
require 'date'

module Pixiv
	module Parser
		class Illust
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] タイトル
			def self.title(page)
				page.at('meta[@property="og:title"]')['content']
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] イラストの概要
			def self.caption(page)
				page.at('meta[@property="og:description"]')['content']
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
				return tags
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] 投稿者の名前
			def self.artist(page)
				page.at('a[@class=avater_m]')['title']
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] 投稿者のID
			def self.userid(page)
				path = 'a[@class=avater_m]'
				page.at(path)['href'].delete('/member.php?id=')
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [Date] 日時用クラスを返す
			def self.date(page)
				path = 'ul[class=meta]'
				Date.strptime(page.at(path).inner_text, "%Y年%m月%d日 %H:%M")
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [Array<String>{width, height}] 画像の大きさ 
			def self.size(page)
				path = 'ul[class=meta]'
				page.search(path).children[1].inner_text.split('×')
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [Array<String>] 使ってるツール
			def self.tools(page)
				path = 'ul[class=tools]'
				result = Array.new
				page.search(path).each{|str| result << str.inner_text }
				result
			end
			
			# @param [Mechanize::Page] 調べたいページ
			# @return [String] 閲覧回数
			def self.view_count(page)
				path = 'dd[class=view-count]'
				page.at(path).inner_text
			end
		end
	end
end