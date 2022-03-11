module RssTogether
  class Groups::MembersController < Groups::BaseController
    before_action :prepare_group

    def index
      @memberships = @group.memberships
    end

    def destroy
      @membership = @group.memberships.find_by(account_id: params[:id])
      @membership.destroy
      redirect_to group_members_path(@group), status: :see_other
    end
  end
end