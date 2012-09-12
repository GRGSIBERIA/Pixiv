=begin
イラスト用クラスのファイル
=end
require 'net/http'
require 'mechanize'

require './pixiv/error.rb'
require './pixiv/client.rb'
require './pixiv/connection.rb'

require './pixiv/presenter/base.rb'
require './pixiv/presenter/image.rb'
require './pixiv/presenter/manga.rb'
require './pixiv/presenter/illust.rb'
require './pixiv/presenter/author.rb'


require './pixiv/api/base.rb'
require './pixiv/api/image.rb'
require './pixiv/api/author.rb'

require './pixiv/parser/image.rb'