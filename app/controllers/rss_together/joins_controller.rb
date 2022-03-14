module RssTogether
  class JoinsController < ApplicationController
    include InvitationTokens

    before_action :skip_authorization
    before_action :prepare_invitation

    def show
      @invitation_tokens << @invitation.token

      if rodauth.logged_in?
        redirect_to rss_together.reader_path(anchor: "invitations")
      else
        render :show
      end
    end

    private

    def prepare_invitation
      # TODO: enforce expiry
      @invitation = Invitation.find_by(token: params[:token])
      redirect_to groups_path if @invitation.blank?
    end
  end
end
