module RssTogether
  class ResolveNewFeedJob < ApplicationJob
    include AfterCommitEverywhere

    queue_as :default

    MAX_LINKS_TO_FOLLOW = 3

    attr_reader :subscription_request

    discard_on NoFeedAtTargetUrlError do |job, error|
      job.fail_with_feedback(
        message: "No RSS or Atom feed was found at this URL",
        error: error,
      )
    end

    discard_on DocumentParsingError do |job, error|
      job.fail_with_feedback(
        message: "There was a problem processing the content at this URL",
        error: error,
      )
    end

    discard_on Faraday::Error do |job, error|
      job.fail_with_feedback(
        message: "Encountered a server error at this URL",
        error: error,
      )
    end

    def perform(subscription_request:, follows: 0)
      @subscription_request = subscription_request

      return unless subscription_request.pending?

      raise NoFeedAtTargetUrlError if follows + 1 > MAX_LINKS_TO_FOLLOW

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
        raise NoFeedAtTargetUrlError
      end
    end

    def fail_with_feedback(message:, error:)
      ActiveRecord::Base.transaction do
        subscription_request.update!(status: :failure)
        # TODO: create resource feedback
        # ResourceFeedback.create!(resource: subscription_request, message: message)
      end
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
      ResolveNewFeedJob.perform_later(subscription_request: subscription_request, follows: follows + 1)
    end
  end
end
