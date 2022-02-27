class RssFeed < SimpleDelegator
  class RssItem < SimpleDelegator
    def title
      __getobj__.title
    end

    def content
      __getobj__.content_encoded || __getobj__.description
    end

    def link
      __getobj__.link
    end

    def description
      Nokogiri::HTML(__getobj__.description || __getobj__.content_encoded).text
    end

    def author
      __getobj__.author || __getobj__.dc_creator
    end

    def published_at
      __getobj__.pubDate
    end

    def guid
      __getobj__.guid
    end
  end

  def items
    __getobj__.items.collect do |item|
      RssItem.new(item).tap { |decorated_item| yield decorated_item if block_given? }
    end
  end

  def title
    __getobj__.channel.title
  end

  def link
    __getobj__.channel.link
  end

  def description
    __getobj__.channel.description
  end

  def language
    __getobj__.channel.language
  end
end
