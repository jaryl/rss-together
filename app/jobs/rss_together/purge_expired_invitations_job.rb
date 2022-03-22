module RssTogether
  class PurgeExpiredInvitationsJob < ApplicationJob
    queue_as :default

    INVITATION_MAX_LIFETIME = 2.weeks.freeze

    def perform(*args)
      Invitation.where("created_at < ?", INVITATION_MAX_LIFETIME.ago).find_each(&:destroy!)
    end
  end
end
