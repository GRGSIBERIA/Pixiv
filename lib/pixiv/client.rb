=begin
Pixivにアクセスするためのクライアントクラス
このクラスインスタンスを利用してPixivにアクセスする
=end
require 'yaml'
require 'mechanize'

module Pixiv
	class Client
		def initialize
			ReadConfiguration()
		end
		
		# ユーザIDやパスワードを保存する
		def ReadConfiguration()
			config = YAML::load_file("./pixiv_config.ini")
			@user_id = config['pixiv']['user_id']
			@password = config['pixiv']['password']
			# yaml example
			# pixiv:
			#		user_id:	hogehoge
			#		password:	puyopuyo
		end
		
		
	end
end