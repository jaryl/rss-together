require 'rails_helper'

module RssTogether
  RSpec.describe MarkSubscriptionItemsAsUnreadJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:feed) { create(:feed) }
    let(:last_processed_at) { 12.hours.ago }
    let(:subscription) { create(:subscription, feed: feed, processed_at: last_processed_at) }
    let(:membership) { create(:membership, group: subscription.group, account: subscription.account) }

    let(:perform) do
      perform_enqueued_jobs do
        described_class.perform_later(subscription)
      end
    end

    before do
      membership
      items
      perform
    end

    describe "#perform" do
      context "with items that should be marked unread" do
        let(:items) { create_list(:item, 8, feed: feed, published_at: 15.days.ago) }

        it "creates the subscription, and updates the request status" do
          expect(membership.marks.unread.count).to eq(8)
          expect(subscription.reload.processed_at).not_to eq(last_processed_at)
        end
      end

      context "with items that should not be marked unread" do
        let(:items) { create_list(:item, 8, feed: feed, published_at: 45.days.ago) }

        it "creates the subscription, and updates the request status" do
          expect(membership.marks.unread.count).to eq(0)
          expect(subscription.reload.processed_at).not_to eq(last_processed_at)
        end
      end
    end
  end
end
