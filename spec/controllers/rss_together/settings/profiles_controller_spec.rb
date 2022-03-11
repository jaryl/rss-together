require 'rails_helper'

module RssTogether
  RSpec.describe Settings::ProfilesController, type: :controller do
    routes { Engine.routes }

    let(:profile) { create(:profile) }
    let(:account) { profile.account }

    before { sign_in account }

    describe "GET #show" do
      before { get :show }

      it { expect(assigns(:profile)).to be_present }
      it { expect(response).to render_template(:show) }
    end

    describe "GET #edit" do
      before { get :edit }

      it { expect(assigns(:profile)).to be_present }
      it { expect(response).to render_template(:edit) }
    end

    describe "PATCH #update" do
      before { patch :update, params: { profile: params } }

      context "with valid params" do
        let(:params) { attributes_for(:profile) }

        it { expect(assigns(:profile)).to be_valid }
        it { expect(response).to redirect_to(settings_profile_path) }
      end

      context "with invalid params" do
        let(:params) { attributes_for(:profile, :invalid) }

        it { expect(assigns(:profile)).not_to be_valid }
        it { expect(response).to render_template(:edit) }
      end
    end
  end
end
