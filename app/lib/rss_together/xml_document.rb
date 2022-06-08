module RssTogether
  class XmlDocument
    def self.with(document:)
      document.remove_namespaces!
      xml_document = new(document: document)

      if document.root&.name == "feed"
        AtomInterface.new(xml_document)
      elsif document.root&.name == "rss"
        RssInterface.new(xml_document)
      else
        raise DocumentParsingError, "Did not detect an Atom or RSS feed"
      end
    end

    attr_reader :document

    def initialize(document:)
      @document = document
    end

    def link_to_feed
      nil
    end

    def xml?
      true
    end

    def html?
      false
    end
  end
end
