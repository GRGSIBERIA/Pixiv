﻿=begin
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
			@agent.user_agent_alias = 'Windows Mozilla'
		end
		
		# @param pixiv_id [String] 自分のPixivのユーザ名
		# @param pass [String] 自分のパスワード
		def Login(pixiv_id, pass)
			form = @agent.get('https://ssl.pixiv.net/login.php').forms[1]
			form.pixiv_id = pixiv_id
			form.pass = pass
			@agent.submit(form)
			
			if @agent.page.at('div[@class="errorArea"]/h2') != nil then
				raise LoginBlockError
			end
			
			if @agent.page.at('span[@class="error"]') != nil then
				raise LoginFailedError
			end
		end
	end
end
