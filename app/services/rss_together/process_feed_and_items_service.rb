module RssTogether
  class ProcessFeedAndItemsService
    def self.call(target_url:, document:, feed: nil)
      feed = Feed.find_or_initialize_by(link: target_url)

      new(
        target_url: target_url,
        document: document,
        feed: feed
      ).send(:perform)
    end

    private

    attr_reader :target_url, :document, :feed

    def initialize(target_url:, document:, feed:)
      @target_url = target_url
      @document = document
      @feed = feed
    end

    def perform
      feed.attributes = {
        title: document.feed.title,
        description: document.feed.description,
        language: document.feed.language,
        processed_at: Time.current,
      }

      document.items.each do |item|
        construct_item(item)
      end

      feed.save!

      { feed: feed }
    end

    def construct_item(item)
      feed.items.find_or_initialize_by(guid: item.guid) do |i|
        i.title = item.title
        i.content = item.content
        i.link = item.link
        i.description = item.description
        i.author = item.author

        if item.published_at > Time.current
          i.published_at = Time.current
          i.rejected_published_at = item.published_at
        else
          i.published_at = item.published_at
        end
      end
    end
  end
end
