module RssTogether
  class Onboarding::InvitationsController < Onboarding::BaseController
    include InvitationTokens

    before_action :redirect_if_no_invitations_present
    before_action :prepare_invitation

    def show
      @form = AcceptInvitationForm.new(current_account, @invitation)
    end

    def accept
      @form = AcceptInvitationForm.new(current_account, @invitation)

      if @form.submit
        @invitation_tokens.delete(@invitation.token)
        flash[:success] = "Joined the group"
        redirect_to main_app.root_path, status: :see_other
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :show, status: :unprocessable_entity
      end
    end

    def reject
      @invitation.destroy!
      @invitation_tokens.delete(@invitation.token)

      flash[:success] = "Invitation rejected"
      redirect_to onboarding_group_path, status: :see_other
    end

    private

    def redirect_if_no_invitations_present
      redirect_to onboarding_group_path if @invitations.empty?
    end

    def prepare_invitation
      @invitation = @invitations.first
      authorize @invitation, :accept?
    end
  end
end
