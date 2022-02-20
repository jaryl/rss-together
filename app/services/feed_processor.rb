require "open-uri"
require "rss"

class FeedProcessor
  attr_reader :raw_url, :feed

  def initialize(raw_url)
    @raw_url = raw_url
  end

  def process!
    rss_feed.items.each do |rss_item|
      next if feed.items.exists?(link: rss_item.link)

      feed.items.build do |item|
        item.title = rss_item.title
        item.description = rss_item.description
        item.link = rss_item.link
        item.author = rss_item.author
        item.published_at = rss_item.pubDate
        item.guid = rss_item.guid
      end
    end

    feed.last_refreshed_at = Time.current

    feed.save!

    yield feed if block_given?

    feed
  end

  def feed
    return @feed if defined? @feed

    @feed = RssTogether::Feed.find_by(link: raw_url) || RssTogether::Feed.find_or_initialize_by(link: rss_feed.channel.link)

    @feed.title = rss_feed.channel.title
    @feed.description = rss_feed.channel.description
    @feed.language = rss_feed.channel.language

    @feed
  end

  private

  def rss_feed
    return @rss_feed if defined? @rss_feed

    URI.open(raw_url) do |content|
      @rss_feed = RSS::Parser.parse(content)
    end

    @rss_feed
  end
end
