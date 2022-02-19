module RssTogether
  class JoinsController < ApplicationController
    before_action :prepare_invitation, only: [:show]

    def show
      @form = AcceptInvitationForm.new(current_account, { token: params[:token] })
    end

    def create
      @form = AcceptInvitationForm.new(current_account, accept_invitation_form_params)
      if @form.submit
        redirect_to my_groups_path, status: :see_other
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def prepare_invitation
      @invitation = Invitation.find_by(token: params[:token])
      redirect_to my_groups_path if @invitation.blank?
    end

    def invitation_params
      params.require(:invitation).permit(:id)
    end

    def accept_invitation_form_params
      params.require(:accept_invitation_form).permit(:token, :display_name)
    end
  end
end
