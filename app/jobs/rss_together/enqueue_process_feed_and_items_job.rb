module RssTogether
  class EnqueueProcessFeedAndItemsJob < ApplicationJob
    queue_as :default

    def perform(*args)
      feeds = Feed.enabled.where("processed_at < ?", RssTogether.feed_processing_interval.ago)
      feeds = feeds.or(Feed.where(processed_at: nil))

      feeds.find_each do |feed|
        ProcessFeedAndItemsJob.perform_later(feed: feed)
      end
    end
  end
end
