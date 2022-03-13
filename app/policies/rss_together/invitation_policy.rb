module RssTogether
  class InvitationPolicy < ApplicationPolicy
    def create?
      record.group.accounts.include?(user)
    end

    def destroy?
      record.sender == user
    end

    class Scope < Scope
      def resolve
        scope.where(group_id: user.group_ids)
      end
    end
  end
end
