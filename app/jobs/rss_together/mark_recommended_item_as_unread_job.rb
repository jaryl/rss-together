module RssTogether
  class MarkRecommendedItemAsUnreadJob < ApplicationJob
    queue_as :default

    def perform(recommendation)
      with_subscription_lock(recommendation) do |target_readers|
        payload = target_readers.map do |reader|
          reader.marker_processing_scheme.process([recommendation.item_id])
        end.flatten.reject(&:empty?)

        Mark.insert_all(payload) unless payload.empty?

        target_readers.each do |reader|
          reader.update!(unread_count: reader.marks.unread.count)
        end
      end
    end

    private

    def with_subscription_lock(recommendation)
      subscription = Subscription.find_by(group_id: recommendation.group.id, feed_id: recommendation.feed.id)
      subscription.with_lock do
        # Avoid inserting markers for readers who already have markers
        all_readers = subscription.group.memberships.reject { |reader| reader == recommendation.membership }
        readers_with_existing_marks = recommendation.item.marks.where(reader: all_readers).map(&:reader)

        yield all_readers - readers_with_existing_marks
      end
    end
  end
end
