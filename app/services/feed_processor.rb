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
        item.content = rss_item.content
        item.link = rss_item.link

        item.description = rss_item.description
        item.author = rss_item.author
        item.published_at = rss_item.published_at
        item.guid = rss_item.guid
      end
    end

    feed.processed_at = Time.current

    feed.save!

    yield feed if block_given?

    feed
  end

  def feed
    return @feed if defined? @feed

    @feed = RssTogether::Feed.find_by(link: raw_url) || RssTogether::Feed.find_or_initialize_by(link: rss_feed.link)


    @feed.title = rss_feed.title
    @feed.description = rss_feed.description
    @feed.language = rss_feed.language

    @feed
  end

  private

  def rss_feed
    # TODO: follow <link>s to find rss url
    # TODO: process images
    return @rss_feed if defined? @rss_feed

    URI.open(raw_url, 'User-Agent' => 'RSS Together') do |content|
      raw_feed = RSS::Parser.parse(content, validate: false)

      case raw_feed.feed_type
      when "rss"
        @rss_feed = RssFeed.new(raw_feed)
      when "atom"
        @rss_feed = AtomFeed.new(raw_feed)
      end
    end

    @rss_feed
  end
end
