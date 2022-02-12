module RssTogether
  class My::GroupsController < ApplicationController
    def index
      @groups = current_account.groups
    end

    def new
      @group = current_account.groups.build
    end

    def create
      @group = current_account.groups.build(group_params)
      if @group.save
        redirect_to my_groups_path
      else
        render :new
      end
    end

    def edit
      @group = current_account.groups.find(params[:id])
    end

    def update
      @group = current_account.groups.find(params[:id])
      if @group.update(group_params)
        redirect_to my_groups_path
      else
        render :new
      end
    end

    private

    def group_params
      params.require(:group).permit(:name)
    end
  end
end
