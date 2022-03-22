module RssTogether
  class Groups::InvitationsController < Groups::BaseController
    before_action :prepare_group

    def index
      @invitations = policy_scope(@group.invitations.includes(:sender, account: :profile))
    end

    def new
      @form = NewInvitationForm.new(@group, current_membership)
      authorize @form.invitation
    end

    def create
      @form = NewInvitationForm.new(@group, current_membership, new_invitation_form_params)
      authorize @form.invitation
      if @form.submit
        flash[:success] = "Invitation will be sent shortly"
        redirect_to group_invitations_path(@group), status: :see_other
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @invitation = @group.invitations.find(params[:id])
      authorize @invitation

      @invitation.destroy!

      flash[:success] = "Invitation to #{@invitation.email} deleted"
      redirect_to group_invitations_path(@group), status: :see_other
    end

    private

    def new_invitation_form_params
      params.require(:new_invitation_form).permit(:email)
    end
  end
end
