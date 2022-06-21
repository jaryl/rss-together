module RssTogether
  class MarkSubscriptionItemsAsUnreadJob < ApplicationJob
    queue_as :default

    def perform(subscription)
      return unless subscription.requires_processing?

      item_ids = subscription.feed.items.where("published_at > ?", RssTogether.items_are_unread_if_published_within.ago).pluck(:id)

      subscription.with_lock do
        if item_ids.present?
          payload = subscription.group.memberships.map do |reader|
            reader.marker_processing_scheme.process(item_ids)
          end.flatten.reject(&:empty?)

          Mark.insert_all(payload)

          subscription.group.memberships.each do |reader|
            reader.update!(unread_count: reader.marks.unread.count)
          end
        end

        subscription.update!(processed_at: Time.current)
      end
    end
  end
end
