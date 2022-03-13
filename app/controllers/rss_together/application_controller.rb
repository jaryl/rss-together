module RssTogether
  class ApplicationController < ::ApplicationController
    include Pundit::Authorization

    # after_action :verify_authorized

    def pundit_user
      current_account
    end
  end
end
