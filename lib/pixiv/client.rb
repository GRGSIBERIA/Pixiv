=begin
Pixivにアクセスするためのクライアントクラス
このクラスインスタンスを利用してPixivにアクセスする
=end
require 'yaml'
require 'mechanize'

require './pixiv/api/base.rb'
require './pixiv/api/image.rb'
require './pixiv/api/artist.rb'
require './pixiv/api/search.rb'

module Pixiv
	class Client
		attr_reader :image, :artist, :search
	
		def initialize
			user_info = ReadConfiguration()
			@connection = Connection.new(user_info['user_id'], user_info['password'])
			@image = API::Image.new(@connection.agent)
			@artist = API::Artist.new(@connection.agent)
			@search = API::Search.new(@connection.agent)
		end
		
		# ユーザIDやパスワードを保存する
		def ReadConfiguration()
			config = YAML::load_file("./pixiv_config.ini")['pixiv']
			# yaml example
			# pixiv:
			#		user_id:	hogehoge
			#		password:	puyopuyo
		end
	end
end