=begin
イラスト用クラスのファイル
=end
require 'net/http'
require 'mechanize'

require './pixiv/error.rb'
require './pixiv/client.rb'
require './pixiv/connection.rb'

require './pixiv/presenter/base.rb'
require './pixiv/presenter/listing.rb'

require './pixiv/presenter/image/image.rb'
require './pixiv/presenter/image/manga.rb'
require './pixiv/presenter/image/illust.rb'
require './pixiv/presenter/image/thumbnail.rb'

require './pixiv/presenter/search/base.rb'
require './pixiv/presenter/search/keywords.rb'
require './pixiv/presenter/search/tags.rb'

require './pixiv/presenter/author/artist.rb'
require './pixiv/presenter/author/detail.rb'

require './pixiv/presenter/instance/picture.rb'
require './pixiv/presenter/instance/tag.rb'

require './pixiv/api/base.rb'
require './pixiv/api/image.rb'
require './pixiv/api/artist.rb'
require './pixiv/api/search.rb'

require './pixiv/parser/image.rb'
require './pixiv/parser/author.rb'
require './pixiv/parser/listing.rb'

require './pixiv/util/tag/function.rb'
require './pixiv/util/tag/cluster.rb'
require './pixiv/util/tag/constellate.rb'
