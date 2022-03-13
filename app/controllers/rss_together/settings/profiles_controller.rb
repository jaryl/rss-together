module RssTogether
  class Settings::ProfilesController < Settings::BaseController
    before_action :prepare_profile

    def show
      authorize @profile
    end

    def edit
      authorize @profile
    end

    def update
      authorize @profile
      if @profile.update(profile_params)
        redirect_to settings_profile_path
      else
        render :edit
      end
    end

    private

    def prepare_profile
      @profile = current_account.profile
    end

    def profile_params
      params.require(:profile).permit(:display_name, :timezone)
    end
  end
end
