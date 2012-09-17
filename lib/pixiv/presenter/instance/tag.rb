=begin
タグ情報を入れるためのクラス
=end
require './pixiv/presenter/base.rb'
require 'cgi'

module Pixiv
	module Presenter
		module Instance
			class Tag < Base
				# @param agent [Mechanize] エージェント
				# @param tag_name [String] タグの名前
				# @param param [Hash]
				# @param param [Int] :used_illust_count そのタグが使用された作品の数
				def initialize(agent, tag_name, param={})
					super(agent)
					param[:used_illust_count] ||= -1
					
					@name = tag_name
					@count = param[:used_illust_count]
				end
				
				# @return [String] タグ名
				def name
					@name
				end
				
				# @return [String] URLエンコード済みのタグ名, 検索などではこちらを使う
				def encoded
					@encoded ||= CGI.escape(@name.toutf8)
				end
				
				# @return [String] タグの件数, -1などはなし
				def count
					@count
				end
			end
		end
	end
end