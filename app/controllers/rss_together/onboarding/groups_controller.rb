module RssTogether
  class Onboarding::GroupsController < Onboarding::BaseController
    def show
      @group = current_account.groups.build
      authorize @group, :new?
    end

    def create
      @group = current_account.groups.build(group_params)
      authorize @group, :new?
      if @group.save
        flash[:success] = "New group created"
        redirect_to main_app.root_path
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :show, status: :unprocessable_entity
      end
    end

    private

    def group_params
      params.require(:group).permit(:name).merge(owner: current_account)
    end
  end
end
