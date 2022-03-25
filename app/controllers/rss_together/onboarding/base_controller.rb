module RssTogether
  class Onboarding::BaseController < ApplicationController
    skip_before_action :redirect_if_not_onboarded
    after_action :update_onboarding_status

    private

    def update_onboarding_status
      current_account.profile.update!(onboarded: true) if current_account.groups.present?
    end
  end
end
