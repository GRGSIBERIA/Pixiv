=begin
検索API用構造体のベースクラス
=end
require './pixiv/parser/listing.rb'

module Pixiv
	module Presenter
		module Search
			class Base
				def initialize(agent, words, param)
					@agent = agent
					@param = param
					@words = words
					@listing = Parser::Listing.new(agent)
				end
				
				# @return [Presenter::Image::Thumbnail] 検索で取得できたサムネ
				def pictures
					@listing.GetThumbnails(@param)
				end
				
				# @return [Int] 検索に引っかかった画像の件数
				def picture_count
					@picture_count ||= GetPictureCount()
				end
				
				# @return [Int] 何ページ存在するか
				def page_count
					@page_count ||= GetMaxPageNum()
				end
				
				# @return [String] パラメータ付きのURI
				def uri
					@uri # コンストラクタで初期化されているはずなのでOK
				end
				
				# @return [String] 結合済みの検索キーワード
				def merged_keywords
					@merged_keywords
				end
				
				# @return [Int] 検索結果に対するページ数
				def GetMaxPageNum()
					picture_count.div(20) + 1
				end
				private :GetMaxPageNum
				
				# @return [Int] 検索に引っかかった画像の件数
				def GetPictureCount()
					@agent.get(@param[:uri])	# 一度最初のページを取得して最大ページ数を取得しておく
					max_page_text = @agent.page.at(@param[:picture_count]).inner_text
					max_page_text.scan(/[0-9]+/)[0].to_i
				end
				private :GetPictureCount
				
				# paramから様々なパラメータを切り出してURIを生成する
				# @return [String] パラメータ付きのURI
				def MakeURI(words, mode)
					uri = 'http://www.pixiv.net/'
					
					case mode
					when "keyword" then 
						uri += 'search.php?'
					when "tag" then 
						uri += 'tags.php?'
					end
					
					uri += MergeKeywords(words, @param[:include], @param[:exclude])
					uri += MakeSinceDate(@param[:since_date])
					uri += MakePartialMatch(mode, @param[:partial_match])
					uri += MakeOrder(@param[:order])
					uri += MakePictureSizeRange(@param[:size])
					uri += MakeAspectRatio(@param[:ratio])
					uri += MakeTool(@param[:tool])
					@uri = uri
				end
				protected :MakeURI
				
				# ツール名をエンコードするだけ
				def MakeTool(tool)
					if tool != nil then
						'&tool=' + CGI.escape(tool.toutf8)
					else
						""
					end
				end
				private :MakeTool
				
				# 日時を生成する
				def MakeSinceDate(since_date)
					if since_date != nil then
						if since_date.class == Date then
							'&scd=' + since_date.strftime("%Y-%m-%d")
						else
							raise ArgumentError, "since_dayはDate型にしてください"
						end
					else
						""
					end
				end
				private :MakeSinceDate
				
				# 並び順を生成する、orderに何か入ってると過去順
				def MakeOrder(order)
					if order != nil then
						"&order=date"
					else
						""
					end
				end
				private :MakeOrder
				
				# 部分一致と完全一致の判定
				def MakePartialMatch(mode, partial_match)
					case mode
					when "keyword" then
						# キーワードの場合は完全一致が存在しない
						'&s_mode=s_tc'
					when "tag" then
						# 部分一致の場合のみ付ける
						partial_match != nil ? '&s_mode=s_tag' : ""
					else
						""
					end
				end
				private :MakePartialMatch
				
				# アスペクト比の設定
				def MakeAspectRatio(ratio)
					if ratio != nil then
						if ratio.class == String then
							case ratio
							when "horizontal"	# 横長
								ratio = "0.5"
							when "vertical"	# 縦長
								ratio = "-0.5"
							when "rectangle" # 正方形
								ratio = "0"
							end
						elsif ratio.class != Float then
							ratio = ratio.to_s
						else
							raise ArgumentError, "型がおかしい:" + ratio.class
						end
						"&ratio=" + ratio
					else
						""
					end
				end
				private :MakeAspectRatio
				
				# 画像の大きさを指定してその範囲の画像を取得する
				# ngtはn以下、nltはn以上の意味
				def MakePictureSizeRange(size)
					if size != nil then
						wgt = nil; hgt = nil; wlt = nil; hlt = nil

						if size.class == String then
							# 画像のサイズを文字列で指定
							case size
							when "small" then
								wgt = 1000
								hgt = 1000
							when "middle" then
								wgt = 3000
								hgt = 3000
								wlt = 1001
								hlt = 1001
							when "large" then
								wlt = 3001
								hlt = 3001
							else
								raise ArgumentError, "small, middle, largeのどれかを指定してください"
							end
						elsif size.class == Hash then
							# 数値で直接指定
							wgt = size[:wgt]
							hgt = size[:hgt]
							wlt = size[:wlt]
							hlt = size[:hlt]
						end
						
						parameters = ""	# ない奴は無視する
						if wgt != nil then parameters += '&wgt=' + wgt.to_s; end;
						if hgt != nil then parameters += '&hgt=' + hgt.to_s; end;
						if wlt != nil then parameters += '&wlt=' + wlt.to_s; end;
						if hlt != nil then parameters += '&hlt=' + hlt.to_s; end;
						parameters
					else
						""
					end
				end
				private :MakePictureSizeRange
				
				# キーワードを結合してエンコードする
				# @param words [Array<String>] キーワード
				# @param include [Array<String>] いずれかのキーワードを含む
				# @param exclude [Array<String>] 除外するキーワード
				# @return [String] URIエンコード済みパラメータ
				def MergeKeywords(words, include, exclude)
					merged_words = ""
					if words.class == Array then
						words.each{|w| merged_words += w + " "}
						merged_words.strip!
					elsif words.class == String then
						merged_words = words
					end
					
					# ～を含む文字列
					if include != nil then
						if include.class != Array then raise ArgumentError, "includeがArray型じゃない"; end
						merged_words += " ("
						include.each{|w| merged_words += w + " OR "}
						merged_words.sub!(/( OR )$/, "")
						merged_words += ")"
					end
					
					# 除外したい文字列
					if exclude != nil then
						if exclude.class != Array then raise ArgumentError, "excludeがArray型じゃない"; end
						exclude.each{|w| merged_words += " -" + w}
					end
					@merged_keywords = merged_words
					"&word=" + CGI.escape(merged_words.toutf8)
				end
				private :MergeKeywords
			end
		end
	end
end