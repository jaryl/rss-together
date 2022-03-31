module RssTogether
  class Error < StandardError; end

  class NoFeedAtTargetUrlError < Error
    attr_reader :url

    def initialize(url:)
      @url = url
      super(self.message)
    end

    def message
      "No RSS or Atom feed was found at #{self.url}"
    end
  end

  class DocumentParsingError < Error; end
  class XmlDocumentParsingError < DocumentParsingError; end
  class HtmlDocumentParsingError < DocumentParsingError; end
  class RssDocumentParsingError < DocumentParsingError; end
  class AtomDocumentParsingError < XmlDocumentParsingError; end
end
