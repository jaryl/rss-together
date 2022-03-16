require 'rails_helper'

module RssTogether
  RSpec.describe JoinsController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:invitation) { create(:invitation, group: group) }

    describe "GET #show" do
      let(:perform_request) { get :show, params: { token: token } }
      let(:token) { invitation.token }

      context "logged in" do
        before { sign_in(account); perform_request }

        it { expect(assigns(:invitation)).to be_present }
        it { expect(response).to redirect_to(main_app.root_path(anchor: "invitations")) }
      end

      context "not logged in" do
        before { request.env["rodauth"] = Rodauth::Rails.rodauth; perform_request }

        it { expect(assigns(:invitation)).to be_present }
        it { expect(response).to render_template(:show) }
      end
    end
  end
end
