require 'rails_helper'

module RssTogether
  RSpec.describe Groups::SubscriptionsController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:subscription) { create(:subscription, group: group) }

    before { sign_in account }

    describe "GET #index" do
      before { subscription; get :index, params: { group_id: group.id } }

      it { expect(assigns(:subscriptions)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end

    describe "GET #new" do
      before { get :new, params: { group_id: group.id } }

      it { expect(assigns(:form)).to be_present }
      it { expect(response).to render_template(:new) }
    end

    describe "POST #create" do
      before { post :create, params: { group_id: group.id, new_subscription_request_form: params } }

      context "with valid params" do
        let(:url) { Faker::Internet.url }
        let(:params) { { target_url: url } }
        let(:feed) { Feed.find_by(link: url) }

        it { expect(assigns(:form).subscription_request).to be_persisted }
        it { expect(response).to redirect_to(group_subscriptions_path(group)) }
      end

      context "with invalid params" do
        let(:params) { { target_url: "some-invalid-url" } }

        it { expect(assigns(:form).subscription_request).not_to be_persisted }
        it { expect(response).to render_template(:new) }
      end
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { group_id: group.id, id: subscription.id } }

      it { expect(assigns(:subscription)).to be_destroyed }
      it { expect(response).to redirect_to(group_subscriptions_path(group)) }
    end
  end
end
