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
			# @param param [Array<String>] :include いずれかを含むキーワード
			# @param param [Array<String>] :exclude 除外するキーワード
			# @param param [Range] :range 検索をかけたいページ範囲
			# @param param [Date] :since_date この日時以降の画像を取得する
			# @param param [Object] :partial_match 部分一致するかどうか, 中に何かが入っていたら部分一致
			# @param param [String] :size small, middle, largeのいずれかで大きさを指定
			# @param param [Hash] :size 大きさを細かく指定したい場合に使う
			# @param :size [Int] :wgt ある幅以下
			# @param :size [Int] :hgt ある高さ以下
			# @param :size [Int] :wlt ある幅以上
			# @param :size [Int] :hlt ある高さ以上
			# @param param [Float] :ratio アスペクト比、+方向で横長、-方向で縦長、0で正方形
			# @param param [String] :ratio vertical, horizontal, rectangleで指定
			def keyword(words=[], param={})
				if words.class != Array then raise ArgumentError, "wordsが配列になっていない"; end
				if words.length <= 0 then raise ArgumentError, "キーワードが指定されていない"; end
				
				param[:uri] = MakeURI(param, words, "keyword")
				#param[:picture_count] = 'div[@class="label"]//div[@class="info"]//span[@class="count"]'
				param[:picture_count] = 'div/div/span'
				param[:image_tag_path] = 'ul[@class="images autopagerize_page_element"]/li/a/p/img'
				param[:a_tag_is_two_parent] = true
				@listing.GetThumbnails(param)
			end
			
			def tag(tagname, param={})
				
			end
			
			# paramから様々なパラメータを切り出してURIを生成する
			# @return [String] パラメータ付きのURI
			def MakeURI(param, words, mode)
				uri = 'http://www.pixiv.net/'
				
				case mode
				when "keyword" then 
					uri += 'search.php?'
				when "tag" then 
					uri += 'tags.php?'
				end
				
				uri += MergeKeywords(words, param[:include], param[:exclude])
				uri += MakeSinceDate(param[:since_date])
				uri += MakePartialMatch(mode, param[:partial_match])
				uri += MakeOrder(param[:order])
				uri += MakePictureSizeRange(param[:size])
				uri += MakeAspectRatio(param[:ratio])
				uri += MakeTool(param[:tool])
			end
			
			# ツール名をエンコードするだけ
			def MakeTool(tool)
				if tool != nil then
					'&tool=' + CGI.escape(tool.toutf8)
				else
					""
				end
			end
			
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
			
			# 並び順を生成する、orderに何か入ってると過去順
			def MakeOrder(order)
				if order != nil then
					"&order=date"
				else
					""
				end
			end
			
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
			
			# キーワードを結合してエンコードする
			# @param words [Array<String>] キーワード
			# @param include [Array<String>] いずれかのキーワードを含む
			# @param exclude [Array<String>] 除外するキーワード
			# @return [String] URIエンコード済みパラメータ
			def MergeKeywords(words, include, exclude)
				merged_words = ""
				words.each{|w| merged_words += w + " "}
				merged_words.strip!
				
				# ～を含む文字列
				if include != nil then
					if include.class != Array then raise ArgumentError, "includeがArray型じゃない"; end
					merged_words += " ("
					include.each{|w| merged_words += w + " OR "}
					merged_words.sub(/( OR )$/, "")
					merged_words += ")"
				end
				
				# 除外したい文字列
				if exclude != nil then
					if exclude.class != Array then raise ArgumentError, "excludeがArray型じゃない"; end
					merged_words += " "
					exclude.each{|w| merged_words += " -" + w}
				end
				
				"&word=" + CGI.escape(merged_words.toutf8)
			end
			private :MergeKeywords
		end
	end
end