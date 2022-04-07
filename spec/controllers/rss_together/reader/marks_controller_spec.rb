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
        before { create(:mark, reader: membership, item: item) }
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
        before { create(:mark, unread: false, reader: membership, item: item) }
        before { post :create, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:mark)).to be_persisted }
        it { expect(assigns(:mark)).to be_unread }

        it { is_expected.to redirect_to(reader_group_item_mark_path(group, item)) }
      end

      context "with no existing mark" do
        before { post :create, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:mark)).to be_persisted }
        it { expect(assigns(:mark)).to be_unread }

        it { is_expected.to redirect_to(reader_group_item_mark_path(group, item)) }
      end
    end

    describe "DELETE #destroy" do
      context "with an existing mark" do
        before { create(:mark, unread: true, reader: membership, item: item) }
        before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:mark)).to be_persisted }
        it { expect(assigns(:mark)).not_to be_unread }

        it { is_expected.to redirect_to(reader_group_item_mark_path(group, item)) }
      end

      context "with no existing mark" do
        before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:mark)).to be_persisted }
        it { expect(assigns(:mark)).not_to be_unread }

        it { is_expected.to redirect_to(reader_group_item_mark_path(group, item)) }
      end
    end

    describe "DELETE #all" do
      before { create_list(:item, 3, feed: subscription.feed) }
      before { Item.all.each { |item| item.marks.create(reader: membership) } }
      before { delete :all, params: { group_id: group.id, item_id: item.id } }

      it { expect(membership.reload.marks.unread).to be_empty }
      it { is_expected.to render_template(:all) }
    end
  end
end
