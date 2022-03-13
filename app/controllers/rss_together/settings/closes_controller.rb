module RssTogether
  class Settings::ClosesController < Settings::BaseController
    def show
      authorize current_account, :destroy?
    end
  end
end
