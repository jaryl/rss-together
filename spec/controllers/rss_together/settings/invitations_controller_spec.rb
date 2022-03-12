require 'rails_helper'

module RssTogether
  RSpec.describe Settings::InvitationsController, type: :controller do
    routes { Engine.routes }

    let(:account) { create(:account) }
    let(:invitation) { create(:invitation, email: account.email) }

    before { sign_in account }

    before { cookies.signed[:_rss_together_invitations] = [invitation.token].to_json }

    describe "GET #index" do
      before { get :index }

      it { expect(assigns(:invitations)).to include(invitation) }
      it { expect(response).to render_template(:index) }
    end

    describe "GET #show" do
      before { get :show, params: { id: invitation } }

      it { expect(assigns(:invitation)).to eq(invitation) }
      it { expect(assigns(:form)).to be_present }
      it { expect(response).to render_template(:show) }
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { id:invitation, accept_invitation_form: params } }

      context "with valid params" do
        let(:params) { { display_name: Faker::Internet.username } }
        it { expect(assigns(:form).membership).to be_valid }
        it { expect(assigns(:form).errors).to be_empty }
        it { expect(response).to redirect_to(settings_invitations_path) }
      end

      context "with invalid params" do
        let(:params) { { display_name: "." } }
        it { expect(assigns(:form).membership).not_to be_valid }
        it { expect(assigns(:form).errors).not_to be_empty }
        it { expect(response).to render_template(:show) }
      end
    end
  end
end
