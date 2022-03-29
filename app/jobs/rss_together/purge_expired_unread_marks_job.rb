module RssTogether
  class PurgeExpiredUnreadMarksJob < ApplicationJob
    queue_as :default

    def perform(*args)
      Mark.system_source.where("created_at < ?", RssTogether.unread_system_markers_expire_after.ago).find_each(&:destroy!)
      Mark.user_source.where("created_at < ?", RssTogether.unread_user_markers_expire_after.ago).find_each(&:destroy!)
    end
  end
end
