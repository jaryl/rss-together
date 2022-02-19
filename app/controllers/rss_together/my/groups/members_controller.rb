module RssTogether
  class My::Groups::MembersController < My::Groups::BaseController
    before_action :prepare_group

    def index
      @members = @group.accounts
    end

    def destroy
      @membership = @group.memberships.find_by(account_id: params[:id])
      @membership.destroy
      redirect_to my_group_members_path(@group), status: :see_other
    end
  end
end
