require 'rails_helper'

module RssTogether
  RSpec.describe Groups::MembersController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:owner) { membership.account }
    let(:group) { membership.group }
    let(:other_membership) { create(:membership, group: group) }

    before { sign_in owner }

    describe "GET #index" do
      before { get :index, params: { group_id: group.id } }

      it { expect(assigns(:memberships)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end

    describe "DELETE #destroy" do
      context "with valid params" do
        before { delete :destroy, params: { group_id: group.id, id: other_membership.account.id } }

        it { expect(assigns(:membership)).to be_destroyed }
        it { expect(response).to redirect_to(group_members_path(group)) }
      end

      context "with invalid params" do
        let(:perform_request) { delete :destroy, params: { group_id: group.id, id: membership.account.id } }

        it { expect(assigns(:membership)).not_to be_present }
      end
    end
  end
end
