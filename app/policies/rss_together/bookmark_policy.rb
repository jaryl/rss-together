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
  end
end
