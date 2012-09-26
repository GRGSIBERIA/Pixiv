=begin
サムネ一覧用の構造体もどき
検索やお気に入り画像一覧などをまとめておくためのもの
=end
require './pixiv/presenter/listing.rb'

module Pixiv
	module Presenter
		class Listing < Base
			# @param agent[Mechanize] エージェント
			# @param items [Array<Presenter::Image::Thumbnails>] サムネ
			# @param items [Array<Presenter::Author::Icon] ユーザアイコン
			# @param type [String] リストの種類, thumbnail, icon
			# @param param [Hash]
			# @param param [Int] :in_page_count 1ページに存在しているコンテンツの数
			# @param param [Int] :content_count 取得できる最大のコンテンツ数
			# @param param [Int] :page_count ページ数
			# @param param [Int] :range ページの取得範囲
			def initialize(agent, type, items, param)
				super(agent)
				@items = items
				@type = type
				@in_page_count = param[:in_page_count]
				@content_conut = param[:content_count]
				@page_count = param[:page_count]
				@range = param[:range]
			end
			
			# @return [String] リストの種類, thumbnail, icon
			def type
				@type
			end
			
			# @return [Array<Presenter::Image::Thumbnail>] サムネ
			# @return [Array<Presenter::Author::Icon] ユーザアイコン
			def items
				@items
			end
			
			# @return [Int] 1ページ中にどれぐらいサムネが存在しているか
			def in_page_count
				@in_page_count
			end
			
			# @return [Int] データの最大数、取得件数ではない
			def content_count
				@content_count
			end
			
			# @return [Int] ページ数
			def page_count
				@page_count
			end
			
			# @return [Range] 取得した範囲
			def range
				@range
			end
		end
	end
end