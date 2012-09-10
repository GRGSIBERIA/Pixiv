=begin
Pixivと通信を行うためのクラス
=end

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require 'mechanize'

module Pixiv
	class LoginFailedError < StandardError; end

	class Connection
		# @param user_id [String] ユーザ名
		# @param password [String] パスワード
		def initialize(user_id, password)
			@agent = Mechanize.new
			Login(user_id, password)
		end
		
		def Login(pixiv_id, pass)
			form = @agent.get('https://ssl.pixiv.net/login.php').forms[1]
			form.pixiv_id = pixiv_id
			form.pass = pass
			@agent.submit(form)
			
			File.write("./test.txt", @agent.page.uri)
		end
	end
end
