=begin
暗号化を行うためのクラス
=end
require 'openssl'
require 'digest/sha1'

module Pixiv
	class Crypt
		# 暗号化されているパスワードを復号化してSSLで使えるように変換する
		# @param userid [String] ユーザID
		# @param pass [String] 暗号化されてるパスワード
		# @return [Hash]
		# @return [String] :user_id ユーザID
		# @return [String] :password パスワード
		def self.Decrypt(userid, pass)
			# 秘密鍵とユーザIDから鍵を生成
			secret = GetSecret()
			digested_userid = Digest::SHA1.hexdigest(userid)	# SHA1で生成したのをさらに
			encrypted_userid = Crypt.EncryptKey(digested_userid, secret)	# クライアント秘密鍵
			# クライアント秘密鍵はユーザIDのハッシュ値を秘密鍵で暗号化したもの
			
			# パスはサーバ秘密鍵、クライアント秘密鍵で二重に暗号化している
			decrypted_pixiv_pass = Crypt.DecryptKey(pass, encrypted_userid)
			
			{:user_id => userid, :password => decrypted_pixiv_pass}
		end
		
		# ユーザIDからユーザに持たせるための秘密鍵を生成する
		# この鍵を使ってパスワードを暗号化して送ってもらう
		# @param userid [String] ユーザID
		# @return [String] 暗号化済みのユーザID, aes-256-cbcで暗号化
		def self.Encrypt(userid)
			secret = CryptGetSecret()
			digested_userid = Digest::SHA1.hexdigest(userid)
			encrypted_userid = Crypt.EncryptKey(digested_userid, secret)
		end
		
		# @return [String] サーバ側で作っておいた秘密鍵
		def self.GetSecret()
			File.read("./pixiv/cryptgen")
		end
		
		# 暗号化
		# @param source 暗号化したい文字列
		# @param pass 暗号化するためのパスワード
		# @return [String] 暗号化した文字列
		def self.EncryptKey(source, pass)
			enc = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
			enc.encrypt
			enc.pkcs5_keyivgen(pass)
			enc.update(source) + enc.final
		end
		
		# 復号化
		# @param source 復号化したい文字列
		# @param pass 暗号化したときのパスワード
		# @return [String] 復号化された文字列
		def self.DecryptKey(source, pass)
			dec = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
			dec.decrypt
			dec.pkcs5_keyivgen(pass)
			dec.update(source) + dec.final
		end
	end
end