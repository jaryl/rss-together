module RssTogether
  class SubscriptionPolicy < ApplicationPolicy
    def create?
      record.group.accounts.include?(user)
    end

    def destroy?
      create?
    end

    class Scope < Scope
      def resolve
        scope.where(group_id: user.group_ids)
      end
    end
  end
end
