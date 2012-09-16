=begin
ユーザ情報ページのデータを切り離すためのもの
=end
require 'date'

module Pixiv
	module Parser
		class Author
			# @return [String] ユーザ名
			def self.name(page)
				page.at('a[@class="avatar_m"]')['title']
			end
			
			# @return [Int] イラストの数
			def self.picture_count(page)
				Author.SearchAlso(page, 'member_illust.php')
			end
			
			# @return [Int] ブックマークの数
			def self.bookmark_count(page)
				Author.SearchAlso(page, 'bookmark.php')
			end
			
			# @return [Int] イメージレスポンスの数
			def self.response_count(page)
				Author.SearchAlso(page, 'response.php')
			end
			
			# @return [Hash<String>] 色々な情報をテーブル単位で詰める
			def self.get_profile_hash(page)
				Author.GetTableHash(page)
			end
			
			# @return [Hash<String, String>] 
			def self.GetTableHash(page)
				table_list = page.search('table[@class="ws_table"]')
				table_hash = {}
				
				# テーブルごとに走査
				for table in table_list do
					# テーブル内の要素をハッシュ化
					title = table.search('td[@class=td1]')
					source = table.search('td[@class=td2]')
					for i in 0..title.length-1 do
						table_hash[title[i].inner_text] = source[i].inner_text
					end
				end
				table_hash
			end
			
			# @param search_str [String] 検索する文字列
			# 使って欲しくないメソッドだけどprivateにできないのかな？
			def self.SearchAlso(page, search_str)
				# 投稿件数やブクマなどは一見するとわからんのでリンクから判別する
				work_alsos = page.search('p[@class=worksAlso]')
				result = nil
				for work in work_alsos do
					# なんかよくわからんが、work.childがnilになる上に、aタグが無視される
					if work.to_html.scan(search_str).length > 0 then
						result = work.inner_text
						break
					end
				end
				
				# 空になってれば存在しなかった
				if result != nil then result.scan(/[0-9]+/)[0].to_i
				else 0 end
			end
			
			def self.extension(page, illust_id)
				img_tag = page.at("li/a/img")
				File.extname(img_tag['src'].split("?")[0])
			end
		end
	end
end