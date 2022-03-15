require 'rails_helper'

module RssTogether
  RSpec.describe Groups::PendingTransfersController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:owner) { membership.account }
    let(:group) { membership.group }
    let(:other_membership) { create(:membership, group: group) }
    let(:account) { other_membership.account }

    before { sign_in account }

    describe "GET #show" do
      let(:perform_request) { get :show, params: { group_id: group } }

      before { create(:group_transfer, group: group, recipient: other_membership); perform_request }

      it { expect(assigns(:transfer)).to be_present }
      it { expect(assigns(:transfer).recipient).to eq(other_membership) }
      it { expect(response).to render_template(:show) }
    end

    describe "POST #create" do
      let(:perform_request) { post :create, params: { group_id: group } }

      before { create(:group_transfer, group: group, recipient: other_membership); perform_request }

      it { expect(assigns(:transfer)).to be_destroyed }
      it { expect(assigns(:group).owner).to eq(account) }
      it { expect(response).to redirect_to(group_transfer_path(group)) }
    end
  end
end
