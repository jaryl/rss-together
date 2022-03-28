require 'rails_helper'

module RssTogether
  RSpec.describe Reader::BookmarksController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:subscription) { create(:subscription, group: group) }
    let(:item) { create(:item, feed: subscription.feed) }

    before { sign_in account }

    describe "GET #show" do
      context "with an existing bookmark" do
        before { create(:bookmark, account: account, item: item) }
        before { get :show, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:bookmark)).to be_present }
        it { is_expected.to render_template(:show) }
      end

      context "with no existing bookmark" do
        before { get :show, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:bookmark)).not_to be_present }
        it { is_expected.to render_template(:show) }
      end
    end

    describe "POST #create" do
      context "with no existing bookmark" do
        before { post :create, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:bookmark)).to be_persisted }
        it { expect(response).to redirect_to(reader_group_item_bookmark_path(group, item)) }
      end

      context "with existing bookmark" do
        before { create(:bookmark, account: account, item: item) }
        before { post :create, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:bookmark)).to be_present }
        it { expect(response).to redirect_to(reader_group_item_bookmark_path(group, item)) }
      end
    end

    describe "DELETE #destroy" do
      context "with no existing bookmark" do
        before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:bookmark)).not_to be_present }
        it { expect(response).to redirect_to(reader_group_item_bookmark_path(group, item)) }
      end

      context "with existing bookmark" do
        before { create(:bookmark, account: account, item: item) }
        before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:bookmark)).to be_destroyed }
        it { expect(response).to redirect_to(reader_group_item_bookmark_path(group, item)) }
      end
    end
  end
end
