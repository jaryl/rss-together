module RssTogether
  class Settings::ProfilesController < Settings::BaseController
    before_action :prepare_profile

    def show
    end

    def edit
    end

    def update
      if @profile.update(profile_params)
        flash[:success] = "Changes saved"
        redirect_to settings_profile_path, status: :see_other
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def prepare_profile
      @profile = current_account.profile
      authorize @profile
    end

    def profile_params
      params.require(:profile).permit(:display_name, :timezone)
    end
  end
end
