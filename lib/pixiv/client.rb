=begin
Pixivにアクセスするためのクライアントクラス
このクラスインスタンスを利用してPixivにアクセスする
=end
require 'yaml'
require 'mechanize'

require './pixiv/api/illust.rb'

module Pixiv
	class Client
		attr_reader :illust
	
		def initialize
			user_info = ReadConfiguration()
			@connection = Connection.new(user_info['user_id'], user_info['password'])
			@illust = API::Illust.new(@connection.agent)
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