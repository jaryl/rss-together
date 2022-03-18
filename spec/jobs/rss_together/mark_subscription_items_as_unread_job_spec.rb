require 'rails_helper'

module RssTogether
  RSpec.describe MarkSubscriptionItemsAsUnreadJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:feed) { create(:feed) }
    let(:subscription) { create(:subscription, feed: feed) }
    let(:membership) { create(:membership, group: subscription.group, account: subscription.account) }

    before { create_list(:item, 8, feed: feed, published_at: 15.days.ago) }

    let(:perform) do
      perform_enqueued_jobs do
        MarkSubscriptionItemsAsUnreadJob.perform_later(subscription: subscription)
      end
    end

    describe "#perform" do
      it "creates the subscription, and updates the request status" do
        membership
        perform
        expect(membership.marks.count).to eq(8)
      end
    end
  end
end
