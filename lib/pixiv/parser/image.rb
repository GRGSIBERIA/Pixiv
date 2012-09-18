=begin
イラストページから情報を取得してくるクラスメソッド
=end
require 'date'

module Pixiv
	module Parser
		class Image
			# NOTE: 引数のpage [Mechanize::Page] は調べたいページのこと
		
			# @return [String] タイトル
			def self.title(page)
				page.at('meta[@property="og:title"]')['content']
			end
			
			# @return [String] イラストの概要
			def self.caption(page)
				page.at('meta[@property="og:description"]')['content']
			end
			
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
			
			# @return [String] 投稿者の名前
			def self.artist(page)
				page.at('a[@class=avater_m]')['title']
			end
			
			# @return [String] 投稿者のID
			def self.userid(page)
				path = 'a[@class=avater_m]'
				page.at(path)['href'].delete('/member.php?id=')
			end
			
			# @return [Date] 日時用クラスを返す
			def self.date(page)
				path = 'ul[@class=meta]'
				Date.strptime(page.at(path).inner_text, "%Y年%m月%d日 %H:%M")
			end
			
			# @return [String] 画像の大きさ、もしくはページ数
			def self.size(page)
				path = 'ul[@class=meta]'
				page.search(path).children[1].inner_text
			end
			
			# @return [Array<String>] 使ってるツール
			def self.tools(page)
				result = Array.new
				page.search('ul[@class=tools]').each{|str| result << str.inner_text }
				result
			end
			
			# @return [String] 閲覧回数
			def self.view_count(page)
				page.at('dd[@class=view-count]').inner_text
			end
			
			# @return [String] 評価回数
			def self.rated_count(page)
				page.at('dd[@class=rated-count]').inner_text
			end
			
			# @return [String] 評価点数
			def self.score_count(page)
				page.at('dd[@class=score-count]').inner_text
			end
			
			# @return [String] 画像ファイルが実際に格納されている場所のパス
			def self.location(page)
				path = 'a[@class=avatar_m]'
				File.dirname(page.at(path).child['src']).sub!(/profile/, 'img')
			end
			
			# @return [String] イラストの拡張子
			def self.extension(page)
				path = 'div[@class="works_display"]'
				File.extname(page.at(path).child.child['src']).split('?')[0]
			end
			
			# @return [Bool] イラストかマンガか
			def self.is_manga(page)
				path = 'div[@class="works_display"]/a'
				page.at(path)['href'].include?('manga')
			end
		end
	end
end