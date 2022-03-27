module RssTogether
  class MarkPolicy < ApplicationPolicy
    def show?
      record.account == user
    end

    def create?
      show?
    end

    def destroy?
      show?
    end

    class Scope < Scope
      def resolve
        scope.where(reader_id: user.membership_ids)
      end
    end
  end
end
