module RssTogether
  class Settings::EmailsController < ApplicationController
    before_action :prepare_account

    def show
    end

    def destroy
      @account.login_change_key&.destroy
      redirect_to settings_email_path, status: :see_other
    end

    private

    def prepare_account
      @account = current_account
    end
  end
end
