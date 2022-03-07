require 'rails_helper'

module RssTogether
  RSpec.describe Settings::EmailsController, type: :controller do
    routes { Engine.routes }

    let(:account) { create(:account) }

    before { sign_in account }

    describe "GET #show" do
      before { get :show }

      it { expect(assigns(:account)).to be_present }
      it { expect(response).to render_template(:show) }
    end

    describe "DELETE #destroy" do
      let(:change_login) { request.env["rodauth"].change_login("some-new-email@example.net") }

      context "with pending email change" do
        before { change_login; delete :destroy }

        it { expect(assigns(:account).login_change_key).to be_destroyed }
        it { expect(response).to redirect_to(settings_email_path) }
      end

      context "without pending email change" do
        before { delete :destroy }

        it { expect(assigns(:account).login_change_key).not_to be_present }
        it { expect(response).to redirect_to(settings_email_path) }
      end
    end
  end
end
