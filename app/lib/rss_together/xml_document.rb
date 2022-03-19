module RssTogether
  class XmlDocument
    def self.parse(content)
      document = Nokogiri::XML(content)
      document.remove_namespaces!

      xml_document = new(document: document)

      if document.root.name == "feed"
        AtomInterface.new(xml_document)
      elsif document.root.name == "rss"
        RssInterface.new(xml_document)
      else
        NullInterace.new(xml_document)
      end
    end

    attr_reader :document

    def initialize(document:)
      @document = document
    end

    def link_to_feed
      nil
    end
  end
end
