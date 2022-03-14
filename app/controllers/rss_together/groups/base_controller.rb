module RssTogether
  class Groups::BaseController < ApplicationController
    private

    def prepare_group
      @group = Group.find(params[:group_id])
    end

    def current_membership
      @current_membership ||= @group.memberships.find_by(account: current_account)
    end
  end
end
