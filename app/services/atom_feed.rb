class AtomFeed < SimpleDelegator
  class AtomItem < SimpleDelegator
    def title
      __getobj__.title.content
    end

    def content
      __getobj__.content.content
    end

    def link
      __getobj__.link.href
    end

    def description
       Nokogiri::HTML(__getobj__.dc_description || __getobj__.content.content).text
    end

    def author
      __getobj__.author&.name&.content || __getobj__.dc_creator
    end

    def published_at
      __getobj__.published.content
    end

    def guid
      __getobj__.id.content
    end
  end

  def items
    __getobj__.entries.collect do |item|
      AtomItem.new(item).tap { |decorated_item| yield decorated_item if block_given? }
    end
  end

  def title
    __getobj__.title.content
  end

  def link
    __getobj__.link.href
  end

  def description
    __getobj__.subtitle&.content
  end

  def language
    __getobj__.lang
  end
end
