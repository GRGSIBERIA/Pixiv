=begin
Pixivと通信を行うためのクラス
=end

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require 'mechanize'

require './pixiv/error.rb'

module Pixiv
	class Connection
		attr_reader :agent
	
		# @param user_id [String] ユーザ名
		# @param password [String] パスワード
		def initialize(user_id, password)
			@agent = Mechanize.new
			Login(user_id, password)
		end
		
		# @param pixiv_id [String] 自分のPixivのユーザ名
		# @param pass [String] 自分のパスワード
		def Login(pixiv_id, pass)
			begin
				form = @agent.get('https://ssl.pixiv.net/login.php').forms[1]
				form.pixiv_id = pixiv_id
				form.pass = pass
				@agent.submit(form)
			rescue
				# 証明書エラーを握りつぶせない！
				# 握りつぶそうとするとログインできない
			end
		end
	end
end
