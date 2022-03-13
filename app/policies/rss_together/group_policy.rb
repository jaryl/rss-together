module RssTogether
  class GroupPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.where(id: user.group_ids)
      end
    end
  end
end
