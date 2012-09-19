=begin
指定したURIをGETしてURIやデータが存在しなかった場合、
どうしても例外で落としたいときに利用する。
存在しなくても問題ない場合は利用しない。
=end
require './pixiv/error.rb'

module Pixiv
	class SafeGet
		# ユーザ情報を取得してきて、それが存在しているのかどうか確認する
		def self.Artist(agent, uri)
			agent.get(uri)
			if agent.page.search('span[@class="error"]').length > 0 then
					raise ArtistNotFoundError.new("指定したユーザは存在しません"); end
		end
	end
end