module RssTogether
  class ProcessFeedAndItemsJob < ApplicationJob
    queue_as :default

    ERROR_KEY = "ProcessFeedAndItemsJob"

    attr_reader :feed

    discard_on Faraday::Error do |job, error|
      context = { feed_url: job.feed.link }
      job.fail_with_feedback(resource: job.feed, error: error, context: context) do |feedback|
        feedback.message = "Server error when requesting this feed"
      end
    end

    discard_on DocumentParsingError do |job, error|
      context = { feed_url: job.feed.link }
      job.fail_with_feedback(resource: job.feed, error: error, context: context) do |feedback|
        feedback.message = "There was a problem processing this feed's content"
      end
    end

    def perform(feed)
      @feed = feed

      response = HttpClient.conn.get(feed.link)
      raw_document = Nokogiri.parse(response.body)
      document = XmlDocument.with(document: raw_document)

      ProcessFeedAndItemsService.call(
        target_url: feed.link,
        document: document,
        feed: feed,
      )

      feed.subscriptions.find_each do |subscription|
        MarkSubscriptionItemsAsUnreadJob.perform_later(subscription)
      end
    end
  end
end
