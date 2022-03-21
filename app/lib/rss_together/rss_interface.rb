module RssTogether
  class RssInterface < SimpleDelegator
    include ActionView::Helpers::SanitizeHelper

    def atom?
      false
    end

    def rss?
      true
    end

    def feed
      updated_at = DateTime.parse(document.at_xpath("//channel/lastBuildDate").text) rescue nil
      FeedElement.new({
        link: document.at_xpath("//channel/link").text,
        title: document.at_xpath("//channel/title").text,
        description: document.at_xpath("//channel/description").text,
        language: "",
        updated_at: updated_at,
      })
    rescue StandardError => e
      raise RssDocumentParsingError, e.message
    end

    def items
      document.xpath("//channel/item").collect do |item|
        description = item.at_xpath("description")&.text
        content_encoded = item.at_xpath("encoded")&.text
        pub_date = DateTime.parse(item.at_xpath("pubDate").text)
        creators = item.xpath("creator").collect { |e| e.text.strip }
        authors = item.xpath("author/name").collect { |e| e.text.strip }
        guid = item.at_xpath("guid").text rescue Digest::MD5.hexdigest(content_encoded.blank? ? description : content_encoded)

        ItemElement.new({
          title: item.at_xpath("title").text,
          content: content_encoded.blank? ? description : content_encoded,
          link: item.at_xpath("link").text,
          description: strip_tags([description, content_encoded].reject(&:blank?).first)&.strip&.truncate(140),
          author: (creators + authors).reject(&:blank?).uniq.join(", "),
          published_at: pub_date,
          guid: guid,
          updated_at: pub_date,
          categories: item.xpath("category").collect(&:text),
        })
      end
    rescue StandardError => e
      raise RssDocumentParsingError, e.message
    end
  end
end
