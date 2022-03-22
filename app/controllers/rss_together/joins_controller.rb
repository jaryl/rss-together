module RssTogether
  class JoinsController < ApplicationController
    include InvitationTokens

    before_action :skip_authorization
    before_action :prepare_invitation

    def show
      @invitation_tokens << @invitation.token

      if rodauth.logged_in?
        redirect_to main_app.root_path(anchor: "invitations")
      else
        session[rodauth.login_redirect_session_key] = request.fullpath
        render :show
      end
    end

    private

    def prepare_invitation
      @invitation = Invitation.find_by(token: params[:token])
      redirect_to groups_path if @invitation.blank?
    end
  end
end
