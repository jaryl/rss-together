module RssTogether
  class ProcessFeedAndItemsJob < ApplicationJob
    queue_as :default

    attr_reader :feed

    discard_on Faraday::Error do |job, error|
      # TODO: create resource feedback
      # ResourceFeedback.create!(resource: job.feed, message: "Server error when requesting this feed")
    end

    discard_on DocumentParsingError do |job, error|
      # TODO: create resource feedback
      # ResourceFeedback.create!(resource: job.feed, message: "There was a problem processing this feed's content")
    end

    def perform(feed:)
      @feed = feed

      response = HttpClient.conn.get(feed.link)
      document = XmlDocument.parse(response.body)

      ProcessFeedAndItemsService.call(
        target_url: feed.link,
        document: document,
        feed: feed,
      )

      feed.subscriptions.find_each do |subscription|
        MarkSubscriptionItemsAsUnreadJob.perform_later(subscription: subscription)
      end
    end
  end
end
