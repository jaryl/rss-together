module RssTogether
  class SubscriptionRequestPolicy < ApplicationPolicy
    def create?
      record.group.accounts.include?(user)
    end

    def cancel?
      create?
    end

    class Scope < Scope
      def resolve
        scope.where(membership_id: user.membership_ids)
      end
    end
  end
end
