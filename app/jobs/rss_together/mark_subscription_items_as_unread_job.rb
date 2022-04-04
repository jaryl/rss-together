module RssTogether
  class MarkSubscriptionItemsAsUnreadJob < ApplicationJob
    queue_as :default

    def perform(subscription)
      return unless subscription.requires_processing?

      item_ids = subscription.feed.items.where("published_at > ?", RssTogether.items_are_unread_if_published_within.ago).pluck(:id)
      items_payload = item_ids.map { |item_id| { item_id: item_id } }

      ActiveRecord::Base.transaction do
        if items_payload.present?
          subscription.group.memberships.each do |membership|
            membership.marks.insert_all(items_payload)
            Membership.reset_counters(membership.id, :marks)
          end
        end

        subscription.update!(processed_at: Time.current)
      end
    end
  end
end
