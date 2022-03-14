module RssTogether
  class Groups::InvitationsController < Groups::BaseController
    before_action :prepare_group

    def index
      @invitations = policy_scope(@group.invitations.includes(:sender))
    end

    def new
      @form = NewInvitationForm.new(@group, current_membership)
      authorize @form.invitation
    end

    def create
      @form = NewInvitationForm.new(@group, current_membership, new_invitation_form_params)
      authorize @form.invitation
      if @form.submit
        redirect_to group_invitations_path(@group), status: :see_other
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @invitation = @group.invitations.find(params[:id])
      authorize @invitation
      @invitation.destroy
      redirect_to group_invitations_path(@group), status: :see_other
    end

    private

    def new_invitation_form_params
      params.require(:new_invitation_form).permit(:email)
    end
  end
end
