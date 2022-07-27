module RssTogether
  class ProcessFeedAndItemsJob < ApplicationJob
    include AfterCommitEverywhere

    queue_as :default

    attr_reader :feed
    alias_method :resource, :feed

    retry_on Faraday::Error, wait: :exponentially_longer, attempts: 10 do |job, error|
      job.fail_with_resource("Network error at #{job.feed.link}") do
        job.feed.update!(enabled: false)
      end
      job.log_and_report_error(error)
    end

    retry_on DocumentParsingError, wait: :exponentially_longer, attempts: 3 do |job, error|
      job.fail_with_resource("There was a problem processing this feed's content") do
        job.feed.update!(enabled: false)
      end
      job.log_and_report_error(error)
    end

    def perform(feed)
      @feed = feed

      document = document_from_feed(feed)

      feed.with_lock do
        ProcessFeedAndItemsService.call(
          target_url: feed.link,
          document: document,
          feed: feed,
        )

        after_commit do
          feed.subscriptions.find_each do |subscription|
            MarkSubscriptionItemsAsUnreadJob.perform_later(subscription)
          end
        end
      end
    end

    def context
      { feed_url: feed.link }
    end

    private

    def document_from_feed(feed)
      response = HttpClient.conn.get(feed.link)
      raw_document = Nokogiri.parse(response.body)
      document = XmlDocument.with(document: raw_document)
    end
  end
end
