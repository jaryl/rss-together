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
        it { expect(response).to redirect_to(my_groups_path) }
      end

      context "with no token" do
        let(:token) { "" }
        it { expect(assigns(:invitation)).not_to be_present }
        it { expect(response).to redirect_to(my_groups_path) }
      end
    end

    describe "POST #create" do
      before { post :create, params: { accept_invitation_form: params } }

      context "with valid params" do
        let(:params) { { token: invitation.token, display_name: Faker::Internet.username } }
        it { expect(assigns(:form).membership).to be_valid }
        it { expect(assigns(:form).errors).to be_empty }
        it { expect(response).to redirect_to(my_groups_path) }
      end

      context "with invalid params" do
        let(:params) { { token: "some invalid token", display_name: "." } }
        it { expect(assigns(:form).membership).not_to be_valid }
        it { expect(assigns(:form).errors).not_to be_empty }
        it { expect(response).to render_template(:show) }
      end
    end
  end
end
