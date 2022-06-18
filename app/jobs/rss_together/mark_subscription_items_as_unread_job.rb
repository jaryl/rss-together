module RssTogether
  class MarkSubscriptionItemsAsUnreadJob < ApplicationJob
    queue_as :default

    def perform(subscription)
      return unless subscription.requires_processing?

      item_ids = subscription.feed.items.where("published_at > ?", RssTogether.items_are_unread_if_published_within.ago).pluck(:id)

      subscription.with_lock do
        if item_ids.present?
          subscription.group.memberships.each do |membership|
            items_payload = membership.marker_processing_scheme.process(item_ids)
            if items_payload.present?
              membership.marks.insert_all(items_payload)
              membership.update!(unread_count: membership.marks.unread.count)
            end
          end
        end

        subscription.update!(processed_at: Time.current)
      end
    end
  end
end
