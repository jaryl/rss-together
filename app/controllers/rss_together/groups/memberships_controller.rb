module RssTogether
  class Groups::MembershipsController < Groups::BaseController
    before_action :prepare_group
    before_action :prepare_membership, only: [:show, :edit, :update, :destroy]

    def show
      authorize @membership
    end

    def edit
      authorize @membership
    end

    def update
      authorize @membership
      if @membership.update(membership_params)
        redirect_to group_membership_path(@group), status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @membership, :leave?
      @membership.destroy
      redirect_to groups_path, status: :see_other
    end

    private

    def prepare_membership
      @membership = @group.memberships.find_by(account_id: current_account.id)
    end

    def membership_params
      params.require(:membership).permit(:display_name)
    end
  end
end
