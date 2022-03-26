module RssTogether
  class Onboarding::BaseController < ApplicationController
    layout "basic"

    skip_before_action :redirect_if_not_onboarded

    before_action :redirect_if_already_onboarded

    after_action :update_onboarding_status

    private

    def redirect_if_already_onboarded
      redirect_to main_app.root_path if current_account.profile.onboarded?
    end

    def update_onboarding_status
      current_account.profile.update!(onboarded: true) if current_account.groups.exists?
    end
  end
end
