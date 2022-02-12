module RssTogether
  class My::Groups::InvitationsController < My::Groups::BaseController
    before_action :prepare_group

    def index
      @invitations = @group.invitations
    end

    def new
      @invitation = @group.invitations.build
    end

    def create
      @invitation = @group.invitations.build(invitation_params)
      if @invitation.save
        redirect_to my_group_invitations_path(@group)
      else
        render :new
      end
    end

    def destroy
      @invitation = @group.invitations.find(params[:id])
      @invitation.destroy
      redirect_to my_group_invitations_path(@group)
    end

    private

    def invitation_params
      params.require(:invitation).permit(:email)
    end
  end
end
