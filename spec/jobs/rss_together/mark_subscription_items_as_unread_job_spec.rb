require 'rails_helper'

module RssTogether
  RSpec.describe MarkSubscriptionItemsAsUnreadJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:feed) { create(:feed) }
    let(:last_processed_at) { 12.hours.ago }
    let(:subscription) { create(:subscription, feed: feed, processed_at: last_processed_at) }
    let(:membership) { create(:membership, group: subscription.group, account: subscription.account) }
    let(:recommendation) {}

    let(:perform) do
      perform_enqueued_jobs do
        described_class.perform_later(subscription)
      end
    end

    before do
      membership
      items
      recommendation
      perform
    end

    describe "#perform" do
      context "with items that should be marked unread" do
        let(:items) { create_list(:item, 8, feed: feed, published_at: 15.days.ago) }

        it "creates 8 unread markers" do
          expect(membership.marks.unread.count).to eq(8)
          expect(subscription.reload.processed_at).not_to eq(last_processed_at)
        end
      end

      context "with items that should not be marked unread" do
        let(:items) { create_list(:item, 8, feed: feed, published_at: 45.days.ago) }

        it "creates 0 unread markers" do
          expect(membership.marks.unread.count).to eq(0)
          expect(subscription.reload.processed_at).not_to eq(last_processed_at)
        end
      end

      context "with recommendation threshold set" do
        let(:items) { create_list(:item, 8, feed: feed, published_at: 15.days.ago) }
        let(:membership) { create(:membership, recommendation_threshold_override: 1, group: subscription.group, account: subscription.account) }
        let(:recommendation) { create(:recommendation, item: items.first, membership: membership) }

        it "creates 1 unread marker" do
          expect(membership.reload.marks.unread.count).to eq(1)
          expect(subscription.reload.processed_at).not_to eq(last_processed_at)
        end
      end
    end
  end
end
