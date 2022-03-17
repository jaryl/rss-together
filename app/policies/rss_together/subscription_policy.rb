module RssTogether
  class SubscriptionPolicy < ApplicationPolicy
    def destroy?
      record.group.accounts.include?(user)
    end

    class Scope < Scope
      def resolve
        scope.where(group_id: user.group_ids)
      end
    end
  end
end
