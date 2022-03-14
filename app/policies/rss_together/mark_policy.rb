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
  end
end
