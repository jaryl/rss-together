module RssTogether
  class GroupsController < ApplicationController
    def index
      @groups = current_account.groups
    end
  end
end
