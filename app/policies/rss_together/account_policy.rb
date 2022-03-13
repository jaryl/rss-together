module RssTogether
  class AccountPolicy < ApplicationPolicy
    def edit?
      update?
    end

    def update?
      record == user
    end

    def destroy?
      update?
    end

  end
end
