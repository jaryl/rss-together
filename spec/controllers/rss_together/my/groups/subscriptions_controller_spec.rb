require 'rails_helper'

module RssTogether
  RSpec.describe My::Groups::SubscriptionsController, type: :controller do
    routes { RssTogether::Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:subscription) { create(:subscription, group: group) }
    let(:feed) { subscription.feed }

    before { sign_in account }

    describe "GET #index" do
      before { subscription; get :index, params: { group_id: group.id } }

      it { expect(assigns(:subscriptions)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end

    describe "GET #new" do
      before { get :new, params: { group_id: group.id } }

      it { expect(assigns(:subscription)).to be_new_record }
      it { expect(response).to render_template(:new) }
    end

    describe "POST #create" do
      before { post :create, params: { group_id: group.id, subscription: params } }

      context "with valid params" do
        let(:params) { { feed_id: feed.id } }
        it { expect(assigns(:subscription)).to be_valid }
        it { expect(response).to redirect_to(my_group_subscriptions_path(group)) }
      end

      context "with invalid params" do
        let(:params) { { feed_id: "some invalid id" } }
        it { expect(assigns(:subscription)).not_to be_valid }
        it { expect(response).to render_template(:new) }
      end
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { group_id: group.id, id: subscription.id } }

      it { expect(assigns(:subscription)).to be_destroyed }
      it { expect(response).to redirect_to(my_group_subscriptions_path(group)) }
    end
  end
end
