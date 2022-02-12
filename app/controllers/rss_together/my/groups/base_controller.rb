module RssTogether
  class My::Groups::BaseController < ApplicationController
    private

    def prepare_group
      @group = Group.find(params[:group_id])
    end
  end
end
