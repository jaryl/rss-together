module RssTogether
  class ProfilePolicy < ApplicationPolicy
    def show?
      update?
    end

    def update?
      record.account == user
    end

    class Scope < Scope
      # NOTE: Be explicit about which records you allow access to!
      # def resolve
      #   scope.all
      # end
    end
  end
end
