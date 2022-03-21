module RssTogether
  class MarkSubscriptionItemsAsUnreadJob < ApplicationJob
    queue_as :default

    UNREAD_LIFETIME = 30.days.freeze

    def perform(subscription:)
      return unless subscription.requires_processing?

      items = subscription.feed.items.where("published_at > ?", UNREAD_LIFETIME.ago)

      ActiveRecord::Base.transaction do
        subscription.group.memberships.each do |membership|
          items_payload = items.map { |item| { reader_id: membership.id, item_id: item.id } }
          membership.marks.insert_all(items_payload)
          Membership.reset_counters(membership.id, :marks)
        end

        subscription.update!(processed_at: Time.current)
      end
    end
  end
end
