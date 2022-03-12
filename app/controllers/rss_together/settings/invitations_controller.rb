module RssTogether
  class Settings::InvitationsController < ApplicationController
    include InvitationTokens

    before_action :prepare_invitation, only: [:show, :destroy]

    def index
    end

    def show
      @form = AcceptInvitationForm.new(current_account, @invitation)
    end

    def destroy
      @form = AcceptInvitationForm.new(current_account, @invitation, accept_invitation_form_params)
      if @form.submit
        @invitation_tokens.delete(@invitation.token)
        redirect_to settings_invitations_path, status: :see_other
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def prepare_invitation
      @invitation = @invitations.find(params[:id])
    end

    def accept_invitation_form_params
      params.require(:accept_invitation_form).permit(:display_name)
    end
  end
end
