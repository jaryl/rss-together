module RssTogether
  class Settings::ClosesController < Settings::BaseController
    def show
      @account = current_account
      authorize @account, :update?
    end
  end
end
