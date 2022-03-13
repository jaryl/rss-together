module RssTogether
  class MarkPolicy < ApplicationPolicy
    def show?
      record.account == user
    end
  end
end
