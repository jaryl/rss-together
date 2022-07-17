module RssTogether
  class ProcessFeedAndItemsJob < ApplicationJob
    include AfterCommitEverywhere

    queue_as :default

    RESOURCE_FEEDBACK_KEYS = [
      "RssTogether::DocumentParsingError",
      "Faraday::Error",
    ].freeze

    attr_reader :feed

    discard_on Faraday::Error, Faraday::ConnectionFailed do |job, error|
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

    retry_on Faraday::TimeoutError, wait: :exponentially_longer, attempts: 10 do |job, error|
      context = { feed_url: job.feed.link }
      job.fail_with_feedback(resource: job.feed, error: error, context: context) do |feedback|
        feedback.message = "Server timed out when requesting this feed"
      end
    end

    def perform(feed)
      @feed = feed

      response = HttpClient.conn.get(feed.link)
      raw_document = Nokogiri.parse(response.body)
      document = XmlDocument.with(document: raw_document)

      feed.with_lock do
        ProcessFeedAndItemsService.call(
          target_url: feed.link,
          document: document,
          feed: feed,
        )

        # TODO: re-implement in web
        # feed.feedback.where(key: RESOURCE_FEEDBACK_KEYS).destroy_all

        after_commit do
          feed.subscriptions.find_each do |subscription|
            MarkSubscriptionItemsAsUnreadJob.perform_later(subscription)
          end
        end
      end
    end
  end
end
