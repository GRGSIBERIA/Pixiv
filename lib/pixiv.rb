=begin
イラスト用クラスのファイル
=end
require 'net/http'
require 'mechanize'

require './pixiv/error.rb'
require './pixiv/client.rb'
require './pixiv/connection.rb'

require './pixiv/presenter/base.rb'

require './pixiv/presenter/image/image.rb'
require './pixiv/presenter/image/manga.rb'
require './pixiv/presenter/image/illust.rb'

require './pixiv/presenter/author/artist.rb'
require './pixiv/presenter/author/detail.rb'

require './pixiv/presenter/instance/picture.rb'

require './pixiv/api/base.rb'
require './pixiv/api/image.rb'
require './pixiv/api/artist.rb'

require './pixiv/parser/image.rb'
require './pixiv/parser/author.rb'