module RssTogether
  class FeedProcessJob < ApplicationJob
    queue_as :default

    def perform(feed)
      FeedProcessor.new(feed.link).process!
    end
  end
end
