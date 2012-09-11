=begin
イラスト用クラスのファイル
=end
require 'net/http'
require 'mechanize'

require './pixiv/error.rb'
require './pixiv/client.rb'
require './pixiv/connection.rb'

require './pixiv/presenter/base.rb'
require './pixiv/presenter/illust.rb'
require './pixiv/presenter/author.rb'

require './pixiv/api/base.rb'
require './pixiv/api/illust.rb'
require './pixiv/api/author.rb'

require './pixiv/parser/illust.rb'