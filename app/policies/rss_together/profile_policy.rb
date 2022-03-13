module RssTogether
  class ProfilePolicy < ApplicationPolicy
    def show?
      update?
    end

    def update?
      record.account == user
    end
  end
end
