module RssTogether
  class RecommendationPolicy < ApplicationPolicy
    def show?
      record.membership.account == user
    end

    def create?
      show?
    end

    def destroy?
      show?
    end
  end
end
