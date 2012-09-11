require './pixiv.rb'

c = Pixiv::Client.new
i = c.illust.show(30042252)
puts i.title
puts i.caption
puts i.tags
puts i.date.to_s
puts i.size
puts i.tools
puts i.view_count