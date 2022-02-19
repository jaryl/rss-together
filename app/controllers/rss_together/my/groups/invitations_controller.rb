module RssTogether
  class My::Groups::InvitationsController < My::Groups::BaseController
    before_action :prepare_group

    def index
      @invitations = @group.invitations
    end

    def new
      @form = NewInvitationForm.new(@group)
    end

    def create
      @form = NewInvitationForm.new(@group, new_invitation_form_params)
      if @form.submit
        redirect_to my_group_invitations_path(@group), status: :see_other
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @invitation = @group.invitations.find(params[:id])
      @invitation.destroy
      redirect_to my_group_invitations_path(@group), status: :see_other
    end

    private

    def new_invitation_form_params
      params.require(:new_invitation_form).permit(:email)
    end
  end
end
