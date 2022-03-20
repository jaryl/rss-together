module RssTogether
  class AtomInterface < SimpleDelegator
    include ActionView::Helpers::SanitizeHelper

    def atom?
      true
    end

    def rss?
      false
    end

    def feed
      FeedElement.new({
        link: document.at_xpath("//link", "rel" => "self")["href"],
        title: document.at_xpath("//title").text,
        description: "",
        language: document.at_xpath("/").root["lang"],
        updated_at: DateTime.parse(document.at_xpath("//updated").text),
      })

    rescue StandardError => e
      raise AtomDocumentParsingError, e.message
    end

    def items
      document.xpath("//entry").collect do |entry|
        summary = entry.at_xpath("summary")&.text
        content = entry.at_xpath("content")&.text

        ItemElement.new({
          title: entry.at_xpath("title").text,
          content: content.blank? ? summary : content,
          link: entry.at_xpath("link")["href"],
          description: strip_tags([summary, content].reject(&:blank?).first)&.strip&.truncate(140),
          author: entry.at_xpath("author/name")&.text,
          published_at: DateTime.parse(entry.at_xpath("published").text),
          guid: entry.at_xpath("id").text,
          updated_at: DateTime.parse(entry.at_xpath("updated").text),
          categories: entry.xpath("category").collect { |e| e["label"] || e["term"] },
        })
      end

    rescue StandardError => e
      raise AtomDocumentParsingError, e.message
    end
  end
end
