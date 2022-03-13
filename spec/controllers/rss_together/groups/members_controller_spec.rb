require 'rails_helper'

module RssTogether
  RSpec.describe Groups::MembersController, type: :controller do
    routes { Engine.routes }

    let(:account) { create(:account) }
    let(:group) { create(:group, owner: account) }
    let(:owner_membership) { create(:membership, group: group, account: account) }
    let(:other_membership) { create(:membership, group: group) }

    before { sign_in account }

    before { owner_membership; other_membership }

    describe "GET #index" do
      before { get :index, params: { group_id: group.id } }

      it { expect(assigns(:memberships)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { group_id: group.id, id: other_membership.account.id } }

      it { expect(assigns(:membership)).to be_destroyed }
      it { expect(response).to redirect_to(group_members_path(group)) }
    end
  end
end
