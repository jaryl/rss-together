module RssTogether
  module Reader
    class GroupsController < BaseController
      def index
        @groups = policy_scope(current_account.groups)
      end
    end
  end
end
