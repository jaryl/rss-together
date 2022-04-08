module RssTogether
  class PurgeExpiredReadMarksJob < ApplicationJob
    queue_as :default

    def perform(*args)
      Mark.read.where("created_at < ?", (RssTogether.items_are_unread_if_published_within + 1.day).ago).find_each(&:destroy!)
    end
  end
end
