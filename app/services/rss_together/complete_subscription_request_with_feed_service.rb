module RssTogether
  class CompleteSubscriptionRequestWithFeedService
    include AfterCommitEverywhere

    def self.call(subscription_request:, feed:)
      new(subscription_request: subscription_request, feed: feed).send(:perform)
    end

    private

    attr_reader :subscription_request, :feed

    def initialize(subscription_request:, feed:)
      @subscription_request = subscription_request
      @feed = feed
    end

    def perform
      subscription = feed.subscriptions.build({
        group: subscription_request.group,
        account: subscription_request.account,
      })

      subscription.save!
      subscription_request.update!(status: :success)

      after_commit do
        MarkSubscriptionItemsAsUnreadJob.perform_later(subscription)
      end

      { subscription: subscription }
    end
  end
end
