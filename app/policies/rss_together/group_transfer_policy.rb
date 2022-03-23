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
      return false if record.created_at < RssTogether.group_transfers_expire_after.ago

      record.recipient.account == user
    end
  end
end
