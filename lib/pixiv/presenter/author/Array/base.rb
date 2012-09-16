=begin
アーティストのイラスト情報を
配列として扱えるようにするためのベースクラス
=end

module Pixiv
	module Presenter
		module Author
			module Array
				class Base
					def initialize(illust_id, param)
						@illust_id = illust_id
						@param = param
					end
				end
			end
		end
	end
end