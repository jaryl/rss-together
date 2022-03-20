module RssTogether
  class EnqueueProcessFeedAndItemsJob < ApplicationJob
    queue_as :default

    PROCESSING_INTERVAL = 12.hours.freeze

    def perform(*args)
      feeds = Feed.enabled.where("processed_at < ?", PROCESSING_INTERVAL.ago)
      feeds = feeds.or(Feed.where(processed_at: nil))

      feeds.find_each do |feed|
        ProcessFeedAndItemsJob.perform_later(feed: feed)
      end
    end
  end
end
