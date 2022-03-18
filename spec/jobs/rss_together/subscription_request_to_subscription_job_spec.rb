require 'rails_helper'

module RssTogether
  RSpec.describe SubscriptionRequestToSubscriptionJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:feed) { create(:feed) }
    let(:subscription_request) { create(:subscription_request, target_url: feed.link) }

    let(:perform) do
      perform_enqueued_jobs do
        SubscriptionRequestToSubscriptionJob.perform_later(subscription_request: subscription_request, feed: feed)
      end
    end

    describe "#perform" do
      it "creates the subscription, and updates the request status" do
        perform
        expect(subscription_request.reload).to be_success
        expect(feed.groups).to include(subscription_request.group)
      end
    end
  end
end
