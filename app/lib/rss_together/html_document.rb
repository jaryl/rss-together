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
      @link_to_feed ||= [
        document.css("link[type='application/atom+xml']").map{ |link| link[:href] }.first,
        document.css("link[type='application/rss+xml']").map{ |link| link[:href] }.first,
      ].reject(&:blank?).first
    end

    def atom?
      false
    end

    def rss?
      false
    end
  end
end
