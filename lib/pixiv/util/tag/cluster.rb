=begin
ユーザ情報から集められたタグを格納する
=end
require './pixiv/util/tag/constellate.rb'

module Pixiv
	module Util
		module Tag
			class Cluster
			  # @param client [Pixiv::Client] クライアント
				# @param userid [Int] ユーザID
				# @param type [String] タグをクラスタリングする種類, posted_tags, bookmarks
				# @param param [Hash]
				# @param param [String] :nickname ニックネーム
				# @param param [Range] :range 探索するページ範囲
				# NOTE:
				# typeはユーザの投稿したイラストに付けられたタグや、ブックマーク全体のタグを指定する
				# bookmarkであれば、ブクマイラストを全て探索し、それらのタグを階層化する
				def initialize(client, type, userid, param={})
					clustered_tags ||= Array.new	# タグの存在しないユーザ
					param[:client] = client
					param[:nickname] ||= "no"
					param[:userid] ||= userid  # Constellateのパラメータ用
					@userid = userid
					@nickname = param[:nickname]
					@type = type
					
					ConstellationTags(param) # タグを取得して集団化
					PrepareTagsMaxCount()	# @maxの設定
					DivideNameFromTags(@tags) # タグ名ごとにタグ階層の分割を行う
				end
				
				# タグを取得して集団化する
				def ConstellationTags(param)
				  @tags = nil
          case @type
          when "posted_tags" then
            @tags = Constellate.PostedTags(@userid, param)  # ユーザ投稿タグのタグ階層の取得
          when "bookmarks" then
            @tags = Constellate.Bookmarks(@userid, param)
          else
            raise ArgumentError, "なんか指定の仕方がおかしい：" + type
          end
          @tags ||= Array.new   # 作品を投稿していないユーザ対策
				end
				
				# タグ名をキーにしたハッシュなタグを生成する
				# @param tags [Array<Array<Presenter::Instance::Tag>>] 階層化済みのタグ
				def DivideNameFromTags(tags)
				  @names = Hash.new
          for line in tags do
            for tag in line do
              @names[tag.name] = tag
            end
          end
				end
				
				# 最も深いタグ階層を設定する
				def PrepareTagsMaxCount()
					if @tags.length <= 0 then
						puts "#{@userid}: 1つ以上タグが付けられたユーザを指定してください"
						@tags = Array.new
						@max = 0
					else
						@max = @tags[@tags.length-1][0].count
					end
				end
				private :PrepareTagsMaxCount
				
				def type
				  @type				  
				end
				
				# @return [Int] タグを所有するユーザID, ない場合は-1
				def userid
					@userid
				end
				
				# @return [String] タグを所有するユーザの名前, ない場合は"no"
				def nickname
					@nickname
				end
				
				# @return [Array<Array<Presenter::Instance::Tag>>] クラスター済みのタグ
				def tags
					@tags
				end
				
				# @return [Hash<String => Presenter::Instance::Tag>] タグの名前からタグを割り出す
				def tag_by_name
					@names
				end
				
				# @return [Int] 一番大きい階層
				def max
					@max
				end
				
				# @return [Float] 一番大きな階層の逆数
				def difference
					@difference ||= 1.0 / max.to_f
				end
				
				# @return [Float] 長さ, 1に近づくほど良く付けられるタグ
				def magnitude(num)
					(num+1).to_f * difference
				end
			end
		end
	end
end