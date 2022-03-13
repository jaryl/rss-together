module RssTogether
  class InvitationPolicy < ApplicationPolicy
    def create?
      record.group.accounts.include?(user)
    end

    def destroy?
      record.sender == user
    end

    def accept?
      record.group.accounts.exclude?(user)
    end

    class Scope < Scope
      def resolve
        scope.where(group_id: user.group_ids)
      end
    end
  end
end
