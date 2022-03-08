module RssTogether
  class GroupsController < ApplicationController
    before_action :prepare_group, only: [:show, :edit, :update, :destroy]
    def index
      @groups = current_account.groups
    end

    def show
    end

    def new
      @group = current_account.groups.build
    end

    def create
      @group = current_account.groups.build(group_params)
      ActiveRecord::Base.transaction do
        @group.save!
        current_account.groups << @group
      end
      redirect_to reader_path(group_id: @group.id), status: :see_other
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end

    def edit
    end

    def update
      if @group.update(group_params)
        redirect_to group_path(@group), status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @group.destroy
      redirect_to groups_path, status: :see_other
    end

    private

    def prepare_group
      @group = current_account.groups.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name).merge(owner: current_account)
    end
  end
end
