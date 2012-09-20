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
			# @param param [Object] :partial_match 部分一致するかどうか, 中に何かが入っていたら部分一致
			# @param param [String] :size small, middle, largeのいずれかで大きさを指定
			# @param param [Hash] :size 大きさを細かく指定したい場合に使う
			# @param :size [Int] :wgt ある幅以下
			# @param :size [Int] :hgt ある高さ以下
			# @param :size [Int] :wlt ある幅以上
			# @param :size [Int] :hlt ある高さ以上
			# @param param [Float] :ratio アスペクト比、+方向で横長、-方向で縦長、0で正方形
			def keyword(words=[], param={})
				if words.class != Array then raise ArgumentError, "wordsが配列になっていない"; end
				if words.length <= 0 then raise ArgumentError, "キーワードが指定されていない"; end
				
				param[:uri] = MakeURI(param, "keyword")
				param[:picture_count] = 'div/div[@class="info"]/span[@class="count"]'
				param[:image_tag_path] = 'ul[@class="images autopagerize_page_element"]/li/a/p/img'
				param[:a_tag_is_two_parent] = true
				@listing.GetThumbnails(param)
			end
			
			# paramから様々なパラメータを切り出してURIを生成する
			# @return [String] パラメータ付きのURI
			def MakeURI(param, mode)
				uri = 'http://www.pixiv.net/search.php?' + MergeKeywords(words)
				
				if param[:since_day] != nil and param[:since_day].class == Date then
					uri += '&scd=' + param[:since_day].strftime("%Y-%m-%d")
				end
				
				case mode
				when "keyword" then
					# キーワードの場合は強制
					uri += '&s_mode=s_tc'
				when "tag" then
					# 部分一致の場合のみ付ける
					uri += param[:partial_match] != nil ? '&s_mode=s_tag' : ""	
				end
				
				uri += param[:order] != nil ? '&order=' + param[:order] : '&order=date_d'
				uri += param[:size] != nil ? MakePictureSizeRange(param[:size]) : ""
				uri += param[:ratio] != nil ? MakeAspectRatio(param[:ratio]) : ""
			end
			
			# アスペクト比の設定
			def MakeAspectRatio(ratio)
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
			end
			
			# 画像の大きさを指定してその範囲の画像を取得する
			# ngtはn以下、nltはn以上の意味
			def MakePictureSizeRange(size)
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