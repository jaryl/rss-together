module RssTogether
  class MarkSubscriptionItemsAsUnreadJob < ApplicationJob
    queue_as :default

    def perform(subscription:)
      return unless subscription.requires_processing?

      items = subscription.feed.items.where("published_at > ?", 30.days.ago)

      ActiveRecord::Base.transaction do
        subscription.group.memberships.each do |membership|
          items_payload = items.map { |item| { reader: membership, item: item } }
          membership.marks.create!(items_payload)
        end

        subscription.update!(processed_at: Time.current)
      end
    end
  end
end
