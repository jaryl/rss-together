module RssTogether
  module InvitationTokens
    extend ActiveSupport::Concern

    included do
      around_action :read_and_persist_tokens
    end

    def read_and_persist_tokens
      raw_tokens = JSON.parse(cookies.signed[:_rss_together_invitations] || "[]")

      @invitations = Invitation.includes(:group).where(token: raw_tokens)
      @invitations = @invitations.where.not(group_id: current_account.group_ids) if rodauth.logged_in?
      @invitation_tokens = @invitations.map(&:token)

      yield

      cookies.signed[:_rss_together_invitations] = JSON.generate(@invitation_tokens.uniq)
    end
  end
end
