require 'rails_helper'

module RssTogether
  RSpec.describe Groups::TransfersController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:owner) { membership.account }
    let(:group) { membership.group }
    let(:other_membership) { create(:membership, group: group) }

    before { sign_in account }

    context "signed in as the group owner" do
      let(:account) { owner }

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
          it { expect(assigns(:form).transfer).to be_new_record }
          it { expect(response).to render_template(:new) }
        end
      end

      describe "POST #create" do
        let(:perform_request) { post :create, params: { group_id: group, group_transfer_form: params } }

        context "with transfer in-flight" do
          let(:params) { Hash.new }

          before { create(:group_transfer, group: group); perform_request }

          it { expect(assigns(:transfer)).to be_present }
          it { expect(response).to redirect_to(group_transfer_path(group)) }
        end

        context "with no transfer in-flight" do
          before { perform_request }

          context "with valid params" do
            let(:params) { { recipient_id: other_membership } }
            it { expect(assigns(:form).transfer).to be_persisted }
            it { expect(response).to redirect_to(group_transfer_path(group)) }
          end

          context "with invalid params" do
            let(:params) { { recipient_id: "some-invalid-id" } }
            it { expect(assigns(:form)).not_to be_persisted }
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
    end
  end
end
