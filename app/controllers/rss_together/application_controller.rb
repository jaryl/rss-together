module RssTogether
  class ApplicationController < ::ApplicationController
    include Pundit::Authorization

    after_action :verify_authorized, except: :index
    after_action :verify_policy_scoped, only: :index

    private

    def pundit_user
      current_account
    end
  end
end
