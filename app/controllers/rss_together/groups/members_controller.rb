module RssTogether
  class Groups::MembersController < Groups::BaseController
    before_action :prepare_group
    before_action :prepare_membership, only: [:destroy]

    def index
      @memberships = policy_scope(@group.memberships.includes(:account))
    end

    def destroy
      @membership.destroy
      redirect_to group_members_path(@group), status: :see_other
    end

    private

    def prepare_membership
      @membership = @group.memberships.find_by(account_id: params[:id])
      authorize @membership
    end
  end
end
