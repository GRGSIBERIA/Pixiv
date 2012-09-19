=begin
指定したURIをGETしてURIやデータが存在しなかった場合、
どうしても例外で落としたいときに利用する。
存在しなくても問題ない場合は利用しない。
=end
require './pixiv/error.rb'

module Pixiv
	class SafeGet
		# ユーザ情報を取得してきて存在しているのかどうか確認する
		def self.Artist(agent, uri)
			if SafeGet.Get(agent, uri) then
				raise ArtistNotFoundError, "指定したユーザは存在しません"
			end
		end
		
		# イラストを取得してきて存在しているのかどうか確認する
		def self.Illust(agent, uri)
			if SafeGet.Get(agent, uri) then
				raise IllustNotFoundError, "指定したイラストは存在しません"
			end
		end
		
		# GETに成功したのかどうかだけ返す
		def self.Get(agent, uri)
			agent.get(uri)
			agent.page.search('span[@class="error"]').length > 0 ? true : false
		end
	end
end