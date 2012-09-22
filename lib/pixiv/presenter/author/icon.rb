=begin
ユーザのアイコン情報
主にブクマユーザのアイコンに利用する
=end
require './pixiv/presenter/base.rb'

module Pixiv
	module Presenter
		module Author
			class Icon < Base
				# @param agent [Mechanize] エージェント
				# @param userid [Int] ユーザID
				# @param nickname [String] ユーザの表示名
				# @param icon [Presenter::Instance::Picture] ユーザのミニアイコン
				def initialize(agent, userid, nickname, icon)
					super(agent)
					@userid = userid
					@nickname = nickname
					@icon = icon
				end
				
				# @return [Int] ユーザID
				def userid
					@userid
				end
				
				# @return [String] サムネのところに表示されているニックネーム
				def nickname
					@nickname
				end
				
				# @return [Presenter::Instance::Picture] サムネのアイコン画像
				def icon
					@icon
				end
			end
		end
	end
end