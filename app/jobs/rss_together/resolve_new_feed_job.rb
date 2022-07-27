module RssTogether
  class ResolveNewFeedJob < ApplicationJob
    queue_as :default

    attr_reader :subscription_request
    alias_method :resource, :subscription_request

    retry_on Faraday::Error, wait: :exponentially_longer, attempts: 10 do |job, error|
      job.fail_with_resource("Network error at #{job.subscription_request.target_url}") do
        job.subscription_request.update!(status: :failure)
      end
      job.log_and_report_error(error)
    end

    discard_on NoFeedAtTargetUrlError do |job, error|
      job.fail_with_resource(error.message) do
        job.subscription_request.update!(status: :failure)
      end
    end

    discard_on DocumentParsingError do |job, error|
      job.fail_with_resource("There was a problem processing the content at #{job.subscription_request.target_url}") do
        job.subscription_request.update!(status: :failure)
      end
      job.log_and_report_error(error)
    end

    def perform(subscription_request, follows = 0)
      @subscription_request = subscription_request

      return unless subscription_request.pending?

      raise NoFeedAtTargetUrlError.new(url: subscription_request.target_url) if follows + 1 > RssTogether.max_links_followed_to_resolve_url

      probe = UrlProbe.from(url: subscription_request.target_url)
      if probe.atom? || probe.rss?
        process_feed_directly!(subscription_request: subscription_request, document: probe.document)
      elsif probe.link_to_feed.present?
        follow_link_to_feed!(
          subscription_request: subscription_request,
          link: probe.link_to_feed,
          follows: follows
        )
      else
        raise NoFeedAtTargetUrlError.new(url: subscription_request.target_url)
      end
    end

    def context
      { feed_url: subscription_request.target_url }
    end

    private

    def process_feed_directly!(subscription_request:, document:)
      ActiveRecord::Base.transaction do
        ProcessFeedAndItemsService.call(
          target_url: subscription_request.target_url,
          document: document,
        ) => { feed: }

        CompleteSubscriptionRequestWithFeedService.call(
          subscription_request: subscription_request,
          feed: feed,
        ) => { subscription: }
      end
    end

    def follow_link_to_feed!(subscription_request:, link:, follows:)
      resolved_url = URI(link).host.nil? ? URI.join(subscription_request.target_url, link) : link
      subscription_request.update!(target_url: resolved_url)
      ResolveNewFeedJob.perform_later(subscription_request, follows + 1)
    end
  end
end
