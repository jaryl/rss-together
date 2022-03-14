module RssTogether
  class BookmarkPolicy < ApplicationPolicy
    def show?
      record.account == user
    end

    def create?
      user.present?
    end

    def destroy?
      show?
    end

    class Scope < Scope
      def resolve
        scope.where(account: user)
      end
    end
  end
end
