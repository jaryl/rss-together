require 'rails_helper'

module RssTogether
  RSpec.describe Reader::MarksController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:subscription) { create(:subscription, group: group) }
    let(:item) { create(:item, feed: subscription.feed) }

    before { sign_in account }

    describe "GET #show" do
      context "with an existing mark" do
        before { create(:mark, account: account, item: item) }
        before { get :show, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:mark)).to be_present }
        it { is_expected.to render_template(:show) }
      end

      context "with no existing mark" do
        before { get :show, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:mark)).not_to be_present }
        it { is_expected.to render_template(:show) }
      end
    end

    describe "POST #create" do
      context "with an existing mark" do
        before { create(:mark, account: account, item: item) }
        before { post :create, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:mark)).to be_persisted }
        it { is_expected.to redirect_to(reader_group_item_mark_path(group, item)) }
      end

      context "with no existing mark" do
        before { post :create, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:mark)).to be_persisted }
        it { is_expected.to redirect_to(reader_group_item_mark_path(group, item)) }
      end
    end

    describe "DELETE #destroy" do
      before { create(:mark, account: account, item: item) }
      before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

      it { expect(assigns(:mark)).to be_destroyed }
      it { is_expected.to render_template(:show) }
    end
  end
end
