module RssTogether
  class Groups::BaseController < ApplicationController
    after_action :verify_authorized, except: :index
    after_action :verify_policy_scoped, only: :index

    private

    def prepare_group
      @group = Group.find(params[:group_id])
    end
  end
end
