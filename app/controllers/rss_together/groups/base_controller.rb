module RssTogether
  class Groups::BaseController < ApplicationController
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def prepare_group
      @group = Group.find(params[:group_id])
    end

    def current_membership
      @current_membership ||= @group.memberships.find_by(account: current_account)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      # flash[:alert] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default

      respond_to do |format|
        format.html { redirect_to reader_path }
        format.turbo_stream { render turbo_stream: turbo_stream.append(turbo_frame_request_id, partial: 'flash') }
      end
    end
  end
end
