=begin
検索用のAPI。
主に検索フォームからタグやキーワードを入力する場合を想定。
=end
require './pixiv/api/base.rb'
require './pixiv/presenter/search/keywords.rb'
require './pixiv/presenter/search/tags.rb'
require 'cgi'

module Pixiv
	module API
		class Search < Pixiv::API::Base
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
				a = Presenter::Search::Keywords.new(@agent, words, param)
				puts a
				a
			end
			
			def tag(tagname, param={})
				Presenter::Search::Tags.new(@agent, tagname, param)
			end
		end
	end
end