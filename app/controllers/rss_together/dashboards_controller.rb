module RssTogether
  class DashboardsController < ApplicationController
    layout "application"

    def show
      @invitations = Invitation.where(email: current_account.email)
    end
  end
end
