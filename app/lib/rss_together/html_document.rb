module RssTogether
  class HtmlDocument
    attr_reader :document

    def self.parse(content)
      document = Nokogiri::HTML(content)
      new(document: document)
    end

    def initialize(document:)
      @document = document
    end

    def link_to_feed
      document.css("link[type='application/rss+xml']").map{ |link| link[:href] }.first
    end
  end
end
