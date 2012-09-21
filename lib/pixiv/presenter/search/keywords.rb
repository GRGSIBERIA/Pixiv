=begin

=end
require './pixiv/presenter/search/base.rb'

module Pixiv
	module Presenter
		module Search
			class Keywords < Base
				def initialize(agent, words, param)
					super(agent, words, param)
					@param[:uri] = MakeURI(words, "keyword")
					@param[:picture_count] = 'div/div/span'
					@param[:image_tag_path] = 'ul[@class="images autopagerize_page_element"]/li/a/p/img'
					@param[:a_tag_is_two_parent] = true
				end
			end
		end
	end
end