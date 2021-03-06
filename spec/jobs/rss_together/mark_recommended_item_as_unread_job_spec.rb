require 'rails_helper'

module RssTogether
  RSpec.describe MarkRecommendedItemAsUnreadJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:recommendation) { create(:recommendation) }
    let(:subscription) { create(:subscription, group: recommendation.group, feed: recommendation.feed) }
    let(:membership) { recommendation.membership }

    let(:perform) do
      perform_enqueued_jobs do
        described_class.perform_later(recommendation)
      end
    end

    before do
      recommendation
      subscription
      other_membership
      perform
    end

    describe "#perform" do
      context "with 2 members" do
        let(:other_membership) { create(:membership, group: membership.group) }

        it "creates 1 unread marker" do
          expect(membership.marks.unread.count).to eq(0)
          expect(other_membership.marks.unread.count).to eq(1)
        end
      end

      context "with only 1 member" do
        let(:other_membership) { {} }

        it "creates no unread markers" do
          expect(membership.marks.unread.count).to eq(0)
        end
      end
    end
  end
end
