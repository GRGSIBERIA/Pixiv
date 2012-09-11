=begin
エラーに関するファイル
=end

module Pixiv
	# 存在しないイラストが呼ばれたら返す
	class IllustNotFoundError < StandardError; end
	
	# 存在しないユーザが呼ばれたら返す
	class UserNotFoundError < StandardError; end
	
	# ログインに失敗したら返す
	class LoginFailedError < StandardError; end
end