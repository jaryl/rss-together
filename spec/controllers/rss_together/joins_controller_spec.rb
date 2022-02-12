require 'rails_helper'

module RssTogether
  RSpec.describe JoinsController, type: :controller do
    routes { RssTogether::Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:invitation) { create(:invitation, group: group) }

    before { sign_in account }

    describe "GET #show" do
      before { get :show, params: { token: token } }

      context "with valid token" do
        let(:token) { invitation.token }
        it { expect(assigns(:invitation)).to be_present }
        it { expect(response).to render_template(:show) }
      end

      context "with invalid token" do
        let(:token) { "some invalid token" }
        it { expect(assigns(:invitation)).not_to be_present }
        it { expect(response).to render_template(:show) }
      end

      context "with no token" do
        let(:token) { "" }
        it { expect(assigns(:invitation)).not_to be_present }
        it { expect(response).to render_template(:show) }
      end
    end

    describe "POST #create" do
      before { post :create, params: { invitation: params } }

      context "with valid params" do
        let(:params) { { id: invitation.id } }
        it { expect(assigns(:invitation)).to be_present }
        it { expect(assigns(:membership)).to be_valid }
        it { expect(response).to redirect_to(my_groups_path) }
      end

      context "with invalid params" do
        let(:params) { { id: "some invalid id" } }
        it { expect(assigns(:invitation)).not_to be_present }
        it { expect(assigns(:membership)).not_to be_valid }
        it { expect(response).to render_template(:show) }
      end
    end
  end
end
