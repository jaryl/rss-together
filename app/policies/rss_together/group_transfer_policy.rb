module RssTogether
  class GroupTransferPolicy < ApplicationPolicy
    def show?
      record.group.owner == user
    end

    def create?
      show?
    end

    def destroy?
      create?
    end

    def accept?
      return false if record.group.owner == user
      record.recipient.account == user
    end

    def pending?
      record.group.accounts.include?(user)
    end
  end
end
