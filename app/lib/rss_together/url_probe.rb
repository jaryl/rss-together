module RssTogether
  class UrlProbe
    attr_reader :url

    attr_reader :document

    def self.from(url:, &block)
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

    def valid_feed_found(&block)
      return unless atom_or_rss_found?
      block.call
    end

    def next_feed_found(&block)
      return if atom_or_rss_found?
      return if !has_next_feed?
      block.call
    end

    def no_feed_found(&block)
      return if atom_or_rss_found?
      return if has_next_feed?
      block.call
    end

    private

    def atom_or_rss_found?
      document.atom? || document.rss?
    end

    def has_next_feed?
      document.link_to_feed.present?
    end
  end
end
