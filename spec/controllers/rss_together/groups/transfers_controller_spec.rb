require 'rails_helper'

module RssTogether
  RSpec.describe Groups::TransfersController, type: :controller do
    routes { Engine.routes }

    let(:group) { create(:group) }
    let(:account) { group.owner }

    let(:membership) { create(:membership, group: group) }

    before { sign_in account }

    describe "GET #show" do
      let(:perform_request) { get :show, params: { group_id: group } }

      context "with transfer in-flight" do
        before { create(:group_transfer, group: group); perform_request }
        it { expect(assigns(:transfer)).to be_present }
        it { expect(response).to render_template(:show) }
      end

      context "with no transfer in-flight" do
        before { perform_request }
        it { expect(assigns(:transfer)).not_to be_present }
        it { expect(response).to render_template(:show) }
      end
    end

    describe "GET #new" do
      let(:perform_request) { get :new, params: { group_id: group } }

      context "with transfer in-flight" do
        before { create(:group_transfer, group: group); perform_request }
        it { expect(assigns(:transfer)).to be_present }
        it { expect(response).to redirect_to(group_transfer_path(group)) }
      end

      context "with no transfer in-flight" do
        before { perform_request }
        it { expect(assigns(:transfer)).to be_new_record }
        it { expect(response).to render_template(:new) }
      end
    end

    describe "POST #create" do
      let(:perform_request) { post :create, params: { group_id: group, group_transfer: params } }

      context "with transfer in-flight" do
        let(:params) { Hash.new }

        before { create(:group_transfer, group: group); perform_request }

        it { expect(assigns(:transfer)).to be_present }
        it { expect(response).to redirect_to(group_transfer_path(group)) }
      end

      context "with no transfer in-flight" do
        before { perform_request }

        context "with valid params" do
          let(:params) { { recipient_id: membership } }
          it { expect(assigns(:transfer)).to be_persisted }
          it { expect(response).to redirect_to(group_transfer_path(group)) }
        end

        context "with valid params" do
          let(:params) { { recipient_id: "some-invalid-id" } }
          it { expect(assigns(:transfer)).not_to be_persisted }
          it { expect(response).to render_template(:new) }
        end
      end
    end

    describe "DELETE #destroy" do
      let(:perform_request) { delete :destroy, params: { group_id: group } }

      before { create(:group_transfer, group: group); perform_request }

      it { expect(assigns(:transfer)).to be_destroyed }
      it { expect(response).to redirect_to(group_transfer_path(group)) }
    end

    describe "GET #pending" do
      let(:account) { membership.account }
      let(:perform_request) { get :pending, params: { group_id: group } }

      before { create(:group_transfer, group: group, recipient: membership); perform_request }

      it { expect(assigns(:transfer)).to be_present }
      it { expect(assigns(:transfer).recipient).to eq(membership) }
      it { expect(response).to render_template(:pending) }
    end

    describe "POST #accept" do
      let(:account) { membership.account }
      let(:perform_request) { post :accept, params: { group_id: group } }

      before { create(:group_transfer, group: group, recipient: membership); perform_request }

      it { expect(assigns(:transfer)).to be_destroyed }
      it { expect(assigns(:group).owner).to eq(account) }
      it { expect(response).to redirect_to(group_transfer_path(group)) }
    end
  end
end
