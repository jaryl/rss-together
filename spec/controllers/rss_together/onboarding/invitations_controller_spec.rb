require 'rails_helper'

module RssTogether
  RSpec.describe Onboarding::InvitationsController, type: :controller do
    routes { Engine.routes }

    let(:profile) { create(:profile, onboarded: false) }
    let(:account) { profile.account }
    let(:invitation) { create(:invitation, email: account.email) }

    before { sign_in account }

    describe "GET #show" do
      context "with invitation present" do
        before { cookies.signed[:_rss_together_invitations] = [invitation.token].to_json }
        before { get :show }

        it { expect(assigns(:form)).to be_present }
        it { expect(response).to render_template(:show) }
      end

      context "without invitation present" do
        before { get :show }
        it { expect(response).to redirect_to(onboarding_group_path) }
      end
    end

    describe "POST #accept" do
      before { cookies.signed[:_rss_together_invitations] = [invitation.token].to_json }
      before { post :accept }

      context "with valid params" do
        let(:params) { { display_name_override: Faker::Internet.username } }

        it { expect(assigns(:form).membership).to be_valid }
        it { expect(assigns(:form).errors).to be_empty }
        it { expect(assigns(:invitation)).to be_destroyed }

        it { expect(response).to redirect_to(main_app.root_path) }
      end
    end

    describe "POST #reject" do
      before { cookies.signed[:_rss_together_invitations] = [invitation.token].to_json }
      before { post :reject }

      it { expect(assigns(:invitation)).to be_destroyed }

      it { expect(response).to redirect_to(onboarding_group_path) }
    end
  end
end
