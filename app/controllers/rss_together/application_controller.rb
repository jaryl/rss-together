module RssTogether
  class ApplicationController < ::ApplicationController
    include Pundit::Authorization

    after_action :verify_authorized, except: :index
    after_action :verify_policy_scoped, only: :index

    before_action :redirect_if_not_onboarded

    private

    def pundit_user
      current_account
    end

    def redirect_if_not_onboarded
      return if !rodauth.logged_in? || current_account.profile.blank?
      redirect_to onboarding_path unless current_account.profile.onboarded?
    end
  end
end
