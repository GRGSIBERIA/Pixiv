=begin
タグを収集するための集団クラス
ユーザからイラスト情報を収集する感じ
=end

module Pixiv
	module Util
		module Tag
			class Constellate
			  # ブクマに登録されているイラストを探索して、
			  # そのイラストのタグを階層付けする
			  # @param param [Hash] パラメータ
			  # @return [<Array<Array<Presenter::Instance::Tag>>] 階層化済みのタグ配列
				def self.Bookmarks(userid, param={})
					illusts = PullImageInformations(userid, param)
					tags = ConstellateTagsFromIllustInfo(illusts)  # ここでタグを綺麗に並べる
				end
				
				# ユーザが投稿したイラストのタグを取得する
        # :clientと:idもしくは:tagsのいずれかが必須
        # @param userid [Int] ユーザID
        # @param param [Hash]
        # @param param [Pixiv::Client] :client クライアント
        # @return [Array<Array<Presenter::Instance::Tag>] 階層ごとにまとめたタグ配列
        def self.PostedTags(userid, param={})
          tags = param[:client].artist.tags(userid)
          if tags == nil then return Array.new; end
          tags.sort{|a, b| a.count <=> b.count}
          cluster = ClusteringTags(tags, param)
        end
        
				# イラストごとにタグを引き出してタグの個数をカウントしていく
				# @param illusts [Array<Presenter::Image::ImageInfo>] 引き出されたイラスト情報
				# @return [Array<Array<Presenter::Instance::Tag>>] 階層化されたタグ配列
				def self.ConstellateTagsFromIllustInfo(illusts)
				  tags = Hash.new
          for illust in illusts do
            illust.tags.each{|tag| 
              tags[tag.name] ||= 0
              tags[tag.name] += 1
            }
          end
          ModifyTagCounts(tags)
				end
				#private :ConstellateTagsFromIllustInfo
								
				# 収集したタグをカウント付きのタグに直す
				# @param tags [Hash<String => Int>]
				# @return [Array<Array<Presenter::Instance::Tag>>] 階層化したタグを返す 
				def self.ModifyTagCounts(tags)
				  max = tags.max{|a,b| a[1] <=> b[1]}[1] # タグ階層の最大値を求めてる
          constellated_tags = Array.new(max)  # 二次元配列を作っておく
          for i in 0..max-1 do
            constellated_tags[i] = Array.new
          end
          tags.each{|name, count| 
            constellated_tags[count-1] << 
               Pixiv::Presenter::Instance::Tag.new(nil, name, {:used_illust_count => count})
            }
          constellated_tags
				end
				#private :ModifyTagCounts
				
				# ブクマのサムネ情報からイラスト情報を引き出す
				# @param userid [Int] ユーザID
				# @param param [Hash] パラメータ
				# @return [Array<Presenter::Image::ImageInfo>] イラストの情報配列
				def self.PullImageInformations(userid, param)
          illusts = Array.new
          thumbnails = param[:client].artist.bookmarks(userid, param)
          thumbnails.items.each{|thumb| 
            illusts << param[:client].image.info(thumb.illust_id)}
          illusts
				end
				#private :PullImageInformations
				
				# タグをまとめる, paramがないバージョン
        # @param tags [Array<Presenter::Instance::Tag>] まとめたいタグ配列
        # @return [Array<Array<Presenter::Instance::Tag>] 階層ごとにまとめたタグ配列
        def self.ClusteringTags(tags, param={})
          tag_cluster = nil
          if tags.length > 0 then
            tag_cluster = MakeTwoDimentionsTagsArray(tags)
          end
          tag_cluster
        end
        #private :ClusteringTags
        
        # タグを二次元配列にまとめる
        # @param tags [Array<Presenter::Instance::Tag>] まとめたいタグ配列
        # @return [Array<Array<Presenter::Instance::Tag>] 階層ごとにまとめたタグ配列
        def self.MakeTwoDimentionsTagsArray(tags)
          max_count = 0   # タグのカウントの最大値を求める
          tags.each{|tag| max_count = tag.count > max_count ? tag.count : max_count}
          tag_cluster = Array.new(max_count)  # 二次元配列の生成
          for i in 0..tag_cluster.length-1 do tag_cluster[i] = Array.new; end
          tags.each{|tag| tag_cluster[tag.count-1] << tag}  # クラスター化したいタグを追加する
          tag_cluster
        end
        #private :MakeTwoDimentionsTagsArray
			end
		end
	end
end