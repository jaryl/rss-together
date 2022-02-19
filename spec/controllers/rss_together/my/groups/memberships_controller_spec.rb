require 'rails_helper'

module RssTogether
  RSpec.describe My::Groups::MembershipsController, type: :controller do
    routes { RssTogether::Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }

    before { sign_in account }

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
        it { expect(response).to redirect_to(my_group_path(group)) }
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
      it { expect(response).to redirect_to(my_groups_path) }
    end
  end
end
