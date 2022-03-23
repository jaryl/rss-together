module RssTogether
  class PurgeExpiredInvitationsJob < ApplicationJob
    queue_as :default

    def perform(*args)
      Invitation.where("created_at < ?", RssTogether.invitations_expire_after.ago).find_each(&:destroy!)
    end
  end
end
