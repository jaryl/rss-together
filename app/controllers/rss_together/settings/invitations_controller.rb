module RssTogether
  class Settings::InvitationsController < Settings::BaseController
    include InvitationTokens

    before_action :prepare_invitation, only: [:show, :accept, :reject]

    def index
      skip_policy_scope
    end

    def show
      @form = AcceptInvitationForm.new(current_account, @invitation)
    end

    def accept
      @form = AcceptInvitationForm.new(current_account, @invitation, accept_invitation_form_params)
      if @form.submit
        @invitation_tokens.delete(@invitation.token)
        flash[:success] = "Joined the group"
        redirect_to settings_invitations_path, status: :see_other
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :show, status: :unprocessable_entity
      end
    end

    def reject
      @invitation.destroy!
      @invitation_tokens.delete(@invitation.token)

      flash[:success] = "Invitation rejected"
      redirect_to settings_invitations_path, status: :see_other
    end

    private

    def prepare_invitation
      @invitation = @invitations.find(params[:id])
      authorize @invitation, :accept?
    end

    def accept_invitation_form_params
      params.require(:accept_invitation_form).permit(:display_name_override)
    end
  end
end
