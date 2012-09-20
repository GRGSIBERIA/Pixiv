=begin
検索用のAPI。
主に検索フォームからタグやキーワードを入力する場合を想定。
=end
require './pixiv/api/base.rb'
require 'cgi'

module Pixiv
	module API
		class Search < Base
			def initialize(agent)
				super(agent)
				@listing = Parser::Listing.new(agent)
			end
			
			# キーワードを指定して検索をかける
			# @param words [Array<String>] 検索したいキーワード
			# @param param [Hash]
			# @param param [Range] :range 検索をかけたいページ範囲
			# @param param [Date] :since_day 日時
			def keyword(words=[], param={})
				if words.class != Array then raise ArgumentError, "wordsが配列になっていない"; end
				if words.length <= 0 then raise ArgumentError, "キーワードが指定されていない"; end
				
				param[:uri] = MakeURI(param)
				param[:picture_count] = 'div/div[@class="info"]/span[@class="count"]'
				param[:image_tag_path] = 'ul[@class="images autopagerize_page_element"]/li/a/p/img'
				param[:a_tag_is_two_parent] = true
				@listing.GetThumbnails(param)
			end
			
			# paramから様々なパラメータを切り出してURIを生成する
			# @return [String] パラメータ付きのURI
			def MakeURI(param)
				param[:order] ||= 'date_d'
				
				uri = 'http://www.pixiv.net/search.php?s_mode=s_tag' + MergeKeywords(words)
				uri += '&order=' + param[:order]
				if param[:since_day] != nil and param[:since_day].class == Date then
					uri += '&scd=' + param[:since_day].strftime("%Y-%m-%d")
				end
				
			end
			
			# キーワードを結合してエンコードする
			# @param words [Array<String>] キーワード
			# @return [String] URIエンコード済みパラメータ
			def MergeKeywords(words)
				merged_words = ""
				words.each(|w| merged_words += words + " ")
				"&word=" + CGI.encode(merged_words)
			end
			private :MergeKeywords
		end
	end
end