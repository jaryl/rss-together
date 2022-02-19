module RssTogether
  class My::Groups::MembershipsController < My::Groups::BaseController
    before_action :prepare_group
    before_action :prepare_membership

    def edit
    end

    def update
      if @membership.update(membership_params)
        redirect_to my_group_path(@group)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @membership.destroy
      redirect_to my_groups_path, status: :see_other
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
