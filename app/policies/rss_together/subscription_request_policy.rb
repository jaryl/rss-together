module RssTogether
  class SubscriptionRequestPolicy < ApplicationPolicy
    def create?
      record.group.accounts.include?(user)
    end
  end
end
