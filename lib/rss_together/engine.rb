module RssTogether
  class Engine < ::Rails::Engine
    isolate_namespace RssTogether

    config.to_prepare do
      ::ApplicationController.class_eval do
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

    config.factory_bot.definition_file_paths << root.join('spec', 'factories').to_s if defined?(FactoryBotRails)

    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot dir: 'spec/factories'
      g.helper false
      g.assets false
      g.view_specs false
      g.request_specs false
      g.controller_specs true
    end
  end
end
