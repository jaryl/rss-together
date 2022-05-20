require "rails_helper"

module RssTogether
  RSpec.describe Groups::SubscriptionsController, type: :controller do
    before { ActiveJob::Base.queue_adapter = :test }

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

    describe "DELETE #destroy" do
      before { delete :destroy, params: { group_id: group.id, id: subscription.id } }

      it { expect(RemoveSubscriptionJob).to have_been_enqueued }
      it { expect(response).to redirect_to(group_subscriptions_path(group)) }
    end
  end
end
