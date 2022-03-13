module RssTogether
  class ReactionPolicy < ApplicationPolicy
    def show?
      record.membership.account == user
    end

    def update?
      show?
    end

    def destroy?
      show?
    end
  end
end
