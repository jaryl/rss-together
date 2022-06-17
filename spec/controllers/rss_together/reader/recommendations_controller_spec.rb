require 'rails_helper'

module RssTogether
  RSpec.describe Reader::RecommendationsController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:subscription) { create(:subscription, group: group) }
    let(:item) { create(:item, feed: subscription.feed) }

    before { sign_in account }

    describe "GET #show" do
      context "with an existing recommendation" do
        before { create(:recommendation, membership: membership, item: item) }
        before { get :show, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:recommendation)).to be_present }
        it { is_expected.to render_template(:show) }
      end

      context "with no existing recommendation" do
        before { get :show, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:recommendation)).not_to be_present }
        it { is_expected.to render_template(:show) }
      end
    end

    describe "POST #create" do
      context "with no existing recommendation" do
        before { post :create, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:recommendation)).to be_persisted }
        it { expect(response).to redirect_to(reader_group_item_recommendation_path(group, item)) }
      end

      context "with existing recommendation" do
        before { create(:recommendation, membership: membership, item: item) }
        before { post :create, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:recommendation)).to be_present }
        it { expect(response).to redirect_to(reader_group_item_recommendation_path(group, item)) }
      end
    end

    describe "DELETE #destroy" do
      context "with no existing recommendation" do
        before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:recommendation)).not_to be_present }
        it { expect(response).to redirect_to(reader_group_item_recommendation_path(group, item)) }
      end

      context "with existing recommendation" do
        before { create(:recommendation, membership: membership, item: item) }
        before { delete :destroy, params: { group_id: group.id, item_id: item.id } }

        it { expect(assigns(:recommendation)).to be_destroyed }
        it { expect(response).to redirect_to(reader_group_item_recommendation_path(group, item)) }
      end
    end
  end
end
