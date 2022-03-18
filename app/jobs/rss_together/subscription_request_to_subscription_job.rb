module RssTogether
  class SubscriptionRequestToSubscriptionJob < ApplicationJob
    queue_as :default

    def perform(subscription_request:, feed:)
      return unless subscription_request.pending?

      if feed.link != subscription_request.target_url
        # TODO: raise an error?
      end

      ActiveRecord::Base.transaction do
        subscription = feed.subscriptions.create!({
          group: subscription_request.group,
          account: subscription_request.account,
        })

        subscription_request.update!(status: :success)

        # after_commit do
        #   MarkSubscriptionItemsAsUnreadJob.perform_later(subscription: subscription)
        # end
      end
    end
  end
end
