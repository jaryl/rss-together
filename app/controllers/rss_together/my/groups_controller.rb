module RssTogether
  class My::GroupsController < ApplicationController
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
      if @group.save
        redirect_to my_group_path(@group)
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @group.update(group_params)
        redirect_to my_group_path(@group)
      else
        render :edit
      end
    end

    def destroy
      @group.destroy
      redirect_to my_groups_path
    end

    private

    def prepare_group
      @group = current_account.groups.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name)
    end
  end
end
