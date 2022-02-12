module RssTogether
  class JoinsController < ApplicationController
    def show
      @invitation = Invitation.find_by(token: params[:token])
    end

    def create
      @invitation = Invitation.find_by(invitation_params)
      @membership = Membership.new(account: current_account, group: @invitation&.group)
      if @membership.save
        redirect_to my_groups_path
      else
        render :show
      end
    end

    private

    def invitation_params
      params.require(:invitation).permit(:id)
    end
  end
end
