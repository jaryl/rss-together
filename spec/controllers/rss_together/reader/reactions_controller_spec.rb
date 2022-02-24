require 'rails_helper'

module RssTogether
  module Reader
    RSpec.describe ReactionsController, type: :controller do
      routes { Engine.routes }

      let(:membership) { create(:membership) }
      let(:group) { membership.group }
      let(:account) { membership.account }
      let(:subscription) { create(:subscription, group: group) }
      let(:item) { create(:item, feed: subscription.feed) }

      before { sign_in account }

      describe "GET #show" do
        context "with an existing reaction" do
          before { create(:reaction, membership: membership, item: item) }
          before { get :show, params: { group_id: group.id, item_id: item.id } }

          it { expect(assigns(:reaction)).to be_present }
          it { is_expected.to render_template(:show) }
        end

        context "with no existing reaction" do
          before { get :show, params: { group_id: group.id, item_id: item.id } }

          it { expect(assigns(:reaction)).not_to be_present }
          it { is_expected.to render_template(:show) }
        end
      end

      describe "GET #edit" do
        context "with an existing reaction" do
          before { create(:reaction, membership: membership, item: item) }
          before { get :edit, params: { group_id: group.id, item_id: item.id } }

          it { expect(assigns(:reaction)).not_to be_new_record }
          it { is_expected.to render_template(:edit) }
        end

        context "with no existing reaction" do
          before { get :edit, params: { group_id: group.id, item_id: item.id } }

          it { expect(assigns(:reaction)).to be_new_record }
          it { is_expected.to render_template(:edit) }
        end
      end

      describe "PATCH #update" do
        let(:perform_action) { patch :update, params: { group_id: group.id, item_id: item.id, reaction: params } }

        context "with an existing reaction" do
          let(:params) { { value: "like" } }

          before { create(:reaction, membership: membership, item: item) }
          before { perform_action }

          it { expect(assigns(:reaction)).to be_persisted }
          it { is_expected.to redirect_to(reader_group_item_reaction_path(group, item)) }
        end

        context "with no existing reaction" do
          let(:params) { { value: "like" } }

          before { perform_action }

          it { expect(assigns(:reaction)).to be_persisted }
          it { is_expected.to redirect_to(reader_group_item_reaction_path(group, item)) }
        end

        context "with invalid params" do
          let(:params) { { value: "some invalid value" } }

          before { perform_action }

          it { expect(assigns(:reaction)).not_to be_persisted }
          it { is_expected.to render_template(:show) }
        end
      end

      describe "DELETE #destroy" do
        context "with an existing reaction" do
          before { create(:reaction, membership: membership, item: item) }
          before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

          it { expect(assigns(:reaction)).to be_destroyed }
          it { is_expected.to render_template(:show) }
        end

        context "with no existing reaction" do
          before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

          it { expect(assigns(:reaction)).not_to be_present }
          it { is_expected.to render_template(:show) }
        end
      end
    end
  end
end
