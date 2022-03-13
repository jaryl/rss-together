module RssTogether
  class ItemPolicy < ApplicationPolicy
    def show?
      user.present?
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
