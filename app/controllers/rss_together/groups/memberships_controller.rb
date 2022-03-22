module RssTogether
  class Groups::MembershipsController < Groups::BaseController
    before_action :prepare_group
    before_action :prepare_membership, only: [:show, :edit, :update]

    def show
    end

    def edit
    end

    def update
      if @membership.update(membership_params)
        flash[:success] = "Changes saved"
        redirect_to group_membership_path(@group), status: :see_other
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @membership = @group.memberships.find_by(account: current_account)
      authorize @membership, :leave?

      @membership.destroy!

      flash.now[:success] = "You have left the group"
      render :destroy
    end

    private

    def prepare_membership
      @membership = @group.memberships.find_by(account: current_account)
      authorize @membership
    end

    def membership_params
      params.require(:membership).permit(:display_name_override)
    end
  end
end
