module RssTogether
  class ApplicationController < ::ApplicationController
    include Pundit::Authorization

    after_action :verify_authorized, except: [:index, :all]
    after_action :verify_policy_scoped, only: [:index, :all]

    before_action :redirect_if_not_onboarded

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def pundit_user
      current_account
    end

    def redirect_if_not_onboarded
      return if !rodauth.logged_in? || current_account.profile.blank?
      redirect_to onboarding_path unless current_account.profile.onboarded?
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      # flash[:alert] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default

      respond_to do |format|
        format.html { redirect_to main_app.root_path }
        format.turbo_stream { render turbo_stream: turbo_stream.append(turbo_frame_request_id, partial: 'flash') }
      end
    end
  end
end
