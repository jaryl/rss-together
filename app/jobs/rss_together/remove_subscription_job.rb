module RssTogether
  class RemoveSubscriptionJob < ApplicationJob
    queue_as :default

    def perform(subscription)
      subscription.with_lock do
        subscription.feed.items.each do |item|
          item.marks.where(reader: subscription.group.memberships).destroy_all
        end

        subscription.destroy!

        subscription.group.memberships.each do |membership|
          membership.lock!
          membership.update!(unread_count: membership.marks.unread.count)
        end
      end
    end
  end
end
