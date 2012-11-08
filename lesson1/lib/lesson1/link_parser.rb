require 'httparty'

module Lesson1
  class LinkParser
    attr_reader :items

    def initialize(url)
      @url = url
      @items = []
    end

    # Load and parse link
    def parse!
      response = HTTParty.get(@url)
      response.body
      # TODO: parse links
      @items << "link1"
    end
  end
end