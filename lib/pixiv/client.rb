=begin
Pixivにアクセスするためのクライアントクラス
このクラスインスタンスを利用してPixivにアクセスする
=end
require 'yaml'
require 'mechanize'

require './pixiv/crypt.rb'
require './pixiv/api/base.rb'
require './pixiv/api/image.rb'
require './pixiv/api/artist.rb'
require './pixiv/api/search.rb'

module Pixiv
	class Client
		attr_reader :image, :artist, :search
	
		# @param param [Hash]
		# @param param [String] :user_id ユーザID
		# @param param [String] :password パスワード
		def initialize(param={})
			user_info = nil
			if param.length > 0 then
				user_info = Crypt.Decrypt(param[:user_id], param[:password])
			else
				user_info = ReadConfiguration()
			end
			@connection = Connection.new(user_info['user_id'], user_info['password'])
			@image = API::Image.new(@connection.agent)
			@artist = API::Artist.new(@connection.agent)
			@search = API::Search.new(@connection.agent)
		end
		
		def Decrypt(param)
			
		end
		
		# ユーザIDやパスワードを保存する
		def ReadConfiguration()
			config = YAML::load_file("./pixiv/pixiv_config.ini")['pixiv']
			# yaml example
			# pixiv:
			#		user_id:	hogehoge
			#		password:	puyopuyo
		end
	end
end