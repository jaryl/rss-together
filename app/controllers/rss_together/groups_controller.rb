module RssTogether
  class GroupsController < ApplicationController
    def index
      @groups = current_account.groups
    end

    def destroy
      @membership = current_account.memberships.find_by(group_id: params[:id])
      @membership.destroy
      redirect_to groups_path
    end
  end
end
