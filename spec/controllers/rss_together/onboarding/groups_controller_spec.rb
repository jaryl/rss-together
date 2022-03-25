require 'rails_helper'

module RssTogether
  RSpec.describe Onboarding::GroupsController, type: :controller do
    routes { Engine.routes }

    let(:profile) { create(:profile) }
    let(:account) { profile.account }

    before { sign_in account }

    describe "GET #show" do
      before { get :show }

      it { expect(assigns(:group)).to be_new_record }
      it { expect(response).to render_template(:show) }
    end

    describe "POST #create" do
      before { post :create, params: { group: params } }

      context "with valid params" do
        let(:params) { attributes_for(:group) }
        it { expect(assigns(:group)).to be_valid }
        it { expect(response).to redirect_to(main_app.root_path) }
      end

      context "with invalid params" do
        let(:params) { attributes_for(:group, :invalid) }
        it { expect(assigns(:group)).not_to be_valid }
        it { expect(response).to render_template(:show) }
      end
    end
  end
end
