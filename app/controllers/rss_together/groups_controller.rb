module RssTogether
  class GroupsController < ApplicationController
    before_action :prepare_group, only: [:show, :edit, :update, :destroy]

    def index
      @memberships = policy_scope(current_account.memberships.includes(:group))
      @groups = @memberships.collect(&:group)
    end

    def show
    end

    def new
      @group = current_account.groups.build
      authorize @group
    end

    def create
      @group = current_account.groups.build(group_params)
      authorize @group

      ActiveRecord::Base.transaction do
        @group.save!
        current_account.groups << @group
      end

      flash[:success] = "New group created"
      redirect_to main_app.root_path(group_id: @group.id), status: :see_other
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] = "We found some input errors, fix them and submit the form again"
      render :new, status: :unprocessable_entity
    end

    def edit
    end

    def update
      if @group.update(group_params)
        flash[:success] = "Changes saved"
        redirect_to group_path(@group), status: :see_other
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @group.destroy!

      flash[:success] = "Group deleted"
      render :destroy
    end

    private

    def prepare_group
      @group = current_account.groups.find(params[:id])
      authorize @group
    end

    def group_params
      params.require(:group).permit(:name).merge(owner: current_account)
    end
  end
end
