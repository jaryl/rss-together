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
      raw_document = Nokogiri.parse(response.body)

      document = case raw_document
      when Nokogiri::HTML4::Document
        HtmlDocument.with(document: raw_document)
      when Nokogiri::XML::Document
        XmlDocument.with(document: raw_document)
      else
        raise DocumentParsingError, "Error parsing document as HTML or XML"
      end

      new(url: url, document: document)
    end

    def initialize(url:, document:)
      @url = url
      @document = document
    end
  end
end
