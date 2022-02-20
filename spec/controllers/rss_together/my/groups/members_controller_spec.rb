require 'rails_helper'

module RssTogether
  RSpec.describe My::Groups::MembersController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }

    before { sign_in account }

    describe "GET #index" do
      before { get :index, params: { group_id: group.id } }

      it { expect(assigns(:memberships)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { group_id: group.id, id: account.id } }

      it { expect(assigns(:membership)).to be_destroyed }
      it { expect(response).to redirect_to(my_group_members_path(group)) }
    end
  end
end
