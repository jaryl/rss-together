module RssTogether
  class GroupPolicy < ApplicationPolicy
    def show?
      record.accounts.include?(user)
    end

    def create?
      user.present?
    end

    def update?
      record.owner == user
    end

    def destroy?
      update?
    end

    class Scope < Scope
      def resolve
        scope.where(id: user.group_ids)
      end
    end
  end
end
