module RssTogether
  # TODO: deal with HTTP errors at this abstraction level

  class UrlProbe
    attr_reader :url

    delegate :atom?, to: :document
    delegate :rss?, to: :document
    delegate :link_to_feed, to: :document

    attr_reader :document

    def self.from(url:)
      response = HttpClient.conn.get(url)

      if (response.headers["content-type"].include?("xml"))
        document = XmlDocument.parse(response.body)
      else
        document = HtmlDocument.parse(response.body)
      end

      new(url: url, document: document)
    end

    def initialize(url:, document:)
      @url = url
      @document = document
    end
  end
end
