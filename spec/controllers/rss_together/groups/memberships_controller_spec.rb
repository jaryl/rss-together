require 'rails_helper'

module RssTogether
  RSpec.describe Groups::MembershipsController, type: :controller do
    routes { Engine.routes }

    let(:owner) { create(:account) }
    let(:group) { create(:group, owner: owner) }
    let(:membership) { create(:membership, group: group) }
    let(:account) { membership.account }

    before { sign_in account }

    describe "GET #show" do
      before { get :show, params: { group_id: group.id } }

      it { expect(assigns(:membership)).to eq(membership) }
      it { expect(response).to render_template(:show) }
    end

    describe "GET #edit" do
      before { get :edit, params: { group_id: group.id } }

      it { expect(assigns(:membership)).to eq(membership) }
      it { expect(response).to render_template(:edit) }
    end

    describe "PATCH #update" do
      before { patch :update, params: { group_id: group.id, membership: params } }

      context "with valid params" do
        let(:params) { attributes_for(:membership) }
        it { expect(assigns(:membership)).to be_valid }
        it { expect(response).to redirect_to(group_membership_path(group)) }
      end

      context "with invalid params" do
        let(:params) { attributes_for(:membership, :invalid) }
        it { expect(assigns(:membership)).not_to be_valid }
        it { expect(response).to render_template(:edit) }
      end
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { group_id: group.id } }

      it { expect(assigns(:membership)).to be_destroyed }
      it { expect(response).to render_template(:destroy) }
    end
  end
end
