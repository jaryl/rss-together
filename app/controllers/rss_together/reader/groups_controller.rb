module RssTogether
  module Reader
    class GroupsController < BaseController
      def index
        @groups = current_account.groups
      end
    end
  end
end
