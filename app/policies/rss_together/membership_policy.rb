module RssTogether
  class MembershipPolicy < ApplicationPolicy

    def show?
      record.account == user
    end

    def update?
      show?
    end

    def destroy?
      return false if record.group.owner != user # only owners can kick members
      record.account != user # cannot kick onself
    end

    def leave?
      record.group.owner != user
    end

    class Scope < Scope
      def resolve
        scope.where(group_id: user.group_ids)
      end
    end
  end
end
