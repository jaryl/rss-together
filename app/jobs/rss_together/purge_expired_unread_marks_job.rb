module RssTogether
  class PurgeExpiredUnreadMarksJob < ApplicationJob
    queue_as :default

    SYSTEM_MARK_LIFETIME = 30.days.freeze
    USER_MARK_LIFETIME = 45.days.freeze

    def perform(*args)
      Mark.system.where("created_at < ?", SYSTEM_MARK_LIFETIME.ago).find_each(&:destroy!)
      Mark.user.where("created_at < ?", USER_MARK_LIFETIME.ago).find_each(&:destroy!)
    end
  end
end
