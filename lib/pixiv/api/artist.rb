=begin
特定のユーザ情報を問い合わせるためのクラス
=end
require './pixiv/api/base.rb'
require './pixiv/parser/listing.rb'
require './pixiv/presenter/image/thumbnail.rb'
require './pixiv/presenter/instance/tag.rb'
require './pixiv/presenter/author/icon.rb'
require './pixiv/safe.rb'

module Pixiv
	module API
		class Artist < Base
			# @param agent [Mechanize] セッションの確立している状態のもの
			def initialize(agent)
				super(agent)
				@listing = Parser::Listing.new(agent)
			end
			
			# ユーザ情報の取得を行う
			# @param userid [Int] ユーザID
			# @return [Presenter::Author::Artist] ユーザの情報など
			def info(userid)
				uri = "http://www.pixiv.net/member.php?id=#{userid}"
				SafeGet.Artist(@agent, uri)
				Presenter::Author::Artist.new(@agent, userid)
			end
			
			# 投稿されたイラストを取得する
			# @param userid [Int] ユーザID
			# @param param [Hash]
			# @param param [Range] :range 表示するページ範囲。1から、限界ページに達しても自動調整される。
			# @param param [Presenter::Instance::Tag] :tag 絞り込みたいタグ
			# @param param [String] :tag 絞り込みたいタグ
			def pictures(userid, param={})
				param[:uri] = "http://www.pixiv.net/member_illust.php?id=#{userid}"
				if param[:tag] != nil then	# タグが有効であれば追加しておく
					tag = param[:tag].class == String ? param[:tag] : param[:tag].name
					param[:uri] += '&tag=' + tag
				end
				param[:uri] += AppendTag(param[:tag])
				param[:picture_count] = 'div[@class="two_column_body"]/h3/span'
				param[:image_tag_path] = 'div[@class="display_works linkStyleWorks"]/ul/li/a/img'
				param[:a_tag_is_two_parent] = false
				@listing.GetThumbnails(param)
			end
			
			# @param uri [String] アクセスしたいURL
			# @param tag [Presenter::Instance::Tag] 絞り込みたいタグ
			# @param tag [String] 絞り込みたいタグ
			# @return [String] もし、指定されていればtagパラメータを返す
			def AppendTag(uri, tag)
				if tag != nil then
					tag_str = tag.class == Presenter::Instance::Tag ?
						tag.name : tag
					"&tag=" + tag_str
				else
					""
				end
			end
			
			# ブックマークに登録したユーザを取得する
			# @param userid [Int] ユーザID
			# @param param [Hash]
			# @param param [Range] :range 表示するページ範囲。1から、限界ページに達しても自動調整される。
			# @return [Array<Presenter::Image::Thumbnail>] 取得できたサムネイル一覧
			def bookmarks(userid, param={})
				param[:uri] = "http://www.pixiv.net/bookmark.php?id=#{userid}"
				param[:picture_count] = 'div[@class="two_column_body"]/h3/span'
				param[:image_tag_path] = 'div[@class="display_works linkStyleWorks"]/ul/li/a/img'
				param[:bookmark_count] = true		# カウントしたいって意味
				param[:a_tag_is_two_parent] = false
				@listing.GetThumbnails(param)
			end
			
			# 投稿されたイラストに付いたタグ一覧を取得する
			# @param userid [Int] ユーザID
			# @return [Array<Presenter::Instance::Tag>] イラストにつけられたタグの配列
			def tags(userid)
				# タグの場合、微妙に形式が異なるので注意
				# 本当にタグとURIと件数だけ
				param = Hash.new
				param[:uri] = "http://www.pixiv.net/member_tag_all.php?id=#{userid}"
				GetTags(param)
			end
			
			# お気に入りに登録されたユーザを取得する
			# @param userid [Int] ユーザID
			# @param param [Hash]
			# @param param [Range] 表示するページ範囲。1から、限界ページに達しても自動調整される。
			# @return [Array<Presenter::Author::Icon>] ユーザのアイコンの配列
			def favorites(userid, param={})
				param[:uri] = "http://www.pixiv.net/bookmark.php?type=user&id=#{userid}"
				param[:custom_max_page_count] = 48
				param[:picture_count] = 'div/div/span[@class=count]'
				param[:image_tag_path] = 'div[@class="usericon"]/a/img'
				@listing.GetUsers(param)
			end
			
			# マイピクのユーザを取得する
			# @param userid [Int] ユーザID
			# @param param [Hash]
			# @param param [Range] :range 表示するページ範囲。1から、限界ページに達しても自動調整される。
			# @return [Array<Presenter::Author::Icon>] ユーザのアイコンの配列
			def mypixiv(userid, param={})
				param[:uri] = "http://www.pixiv.net/mypixiv_all.php?id=#{userid}"
				param[:custom_max_page_count] = 18
				param[:picture_count] = 'div/div/span[@class=count]'
				param[:image_tag_path] = 'div[@class="usericon"]/a/img'
				@listing.GetUsers(param)
			end
			
			# レスポンスに応じたイラストを取得する
			# @param userid [Int] ユーザID
			# @return [Array<Presenter::Image::Thumbnail>] レスポンスに応じたイラストのサムネ配列
			def responses(userid, param={})
				param[:uri] = "http://www.pixiv.net/response.php?mode=all&id=#{userid}"
				param[:picture_count] = 'div[@class="one_column_top"]/div/p'
				param[:image_tag_path] = 'div[@class="search_a2_result linkStyleWorks"]/ul/li/a/img'
				param[:a_tag_is_two_parent] = false
				@listing.GetThumbnails(param)
			end
			
			# @param param [Hash]
			# @param param [String] :uri ユーザが付けたタグ一覧を取得しに行くためのURI
			def GetTags(param)
				# ページを取得して行ごとにタグ情報を取得してくる
				result_tags = Array.new
				@agent.get(param[:uri])
				used_tag_counts = @agent.page.search('div[@class="tagListNaviBody"]/dl/dt')
				tag_lines = @agent.page.search('div[@class="tagListNaviBody"]/dl/dd')
				
				# 1行（タグ数カウント）ごとに格納する感じ
				for line_num in 0..used_tag_counts.length-1 do
					GetTagsLine(result_tags, used_tag_counts[line_num], tag_lines[line_num])
				end
				result_tags
			end
			
			# 1行ごとのタグを収集する
			# @param result_tags [Array<Tag>] カウントと対応したタグが収納される
			# @param tags_count [Array<Element>] 1行の中に複数のタグが入っている数
			# @param tags [Array<Element>] 1行の中に入っているタグの集合
			def GetTagsLine(result_tags, tags_count, tags)
				# タグが利用されたイラスト数と実際の名前を取得して格納する
				count = tags_count.inner_text.to_i
				tags.search('a').each{|tag|
					result_tags << Presenter::Instance::Tag.new(
						@agent, tag.inner_text, {:used_illust_count => count})
				}
			end
		end
	end
end