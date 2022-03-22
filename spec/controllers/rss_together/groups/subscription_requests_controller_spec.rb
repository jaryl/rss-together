require "rails_helper"

module RssTogether
  RSpec.describe Groups::SubscriptionRequestsController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:subscription) { create(:subscription, group: group) }

    before { sign_in account }

    describe "GET #processing" do
      before { get :new, params: { group_id: group.id } }

      it { expect(assigns(:form)).to be_present }
      it { expect(response).to render_template(:new) }
    end

    describe "POST #create" do
      before { allow(ResolveNewFeedJob).to receive(:perform_later) }

      before { post :create, params: { group_id: group.id, new_subscription_request_form: params } }

      context "with valid params" do
        let(:url) { Faker::Internet.url }
        let(:params) { { target_url: url } }
        let(:feed) { Feed.find_by(link: url) }

        it { expect(assigns(:form).subscription_request).to be_persisted }
        it { expect(response).to render_template(:create) }
      end

      context "with invalid params" do
        let(:params) { { target_url: "some-invalid-url" } }

        it { expect(assigns(:form).subscription_request).not_to be_persisted }
        it { expect(response).to render_template(:new) }
      end
    end

    describe "GET #processing" do
      let(:subscription_request) { create(:subscription_request, membership: membership) }

      before { subscription_request; get :processing, params: { group_id: group.id } }

      it { expect(assigns(:subscription_requests)).not_to be_empty }
      it { expect(response).to render_template(:processing) }
    end
  end
end
