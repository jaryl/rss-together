module RssTogether
  class NoFeedFoundError < Error; end

  class ResolveNewFeedJob < ApplicationJob
    include AfterCommitEverywhere

    MAX_FOLLOWS = 3

    discard_on NoFeedFoundError do |job, error|
      # TODO: report error
    end

    queue_as :default

    def perform(subscription_request:, follows: 0)
      return unless subscription_request.pending?

      error_on_no_feed_found!(subscription_request: subscription_request) if follows > MAX_FOLLOWS

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
        error_on_no_feed_found!(subscription_request: subscription_request)
      end
    end

    private

    def error_on_no_feed_found!(subscription_request:)
      ActiveRecord::Base.transaction do
        subscription_request.update!(status: :failure)
        # TODO: create resource feedback

        after_commit do
          raise NoFeedFoundError
        end
      end
    end

    def process_feed_directly!(subscription_request:, document:)
      feed = Feed.find_or_initialize_by(link: subscription_request.target_url) do |f|
        f.title = document.feed.title
        f.description = document.feed.description
        f.language = document.feed.language
      end

      document.items.each do |item|
        feed.items.build({
          title: item.title,
          content: item.content,
          link: item.link,
          description: item.description,
          author: item.author,
          published_at: item.published_at,
          guid: item.guid,
        })
      end

      ActiveRecord::Base.transaction do
        feed.save!

        subscription = feed.subscriptions.create!({
          group: subscription_request.group,
          account: subscription_request.account,
        })

        subscription_request.update!(status: :success)

        after_commit do
          MarkSubscriptionItemsAsUnreadJob.perform_later(subscription: subscription)
        end
      end
    end

    def follow_link_to_feed!(subscription_request:, link:, follows:)
      resolved_url = URI(link).host.nil? ? URI.join(subscription_request.target_url, link) : link

      ActiveRecord::Base.transaction do
        subscription_request.update!(target_url: resolved_url)

        after_commit do
          ResolveNewFeedJob.perform_later(subscription_request: subscription_request, follows: follows + 1)
        end
      end
    end
  end
end
