require 'rails_helper'

module RssTogether
  RSpec.describe RemoveSubscriptionJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:subscription) { create(:subscription) }
    let(:membership) { create(:membership, group: subscription.group) }
    let(:item_1) { create(:item, feed: subscription.feed) }
    let(:item_2) { create(:item, feed: subscription.feed) }

    let(:perform) do
      perform_enqueued_jobs { described_class.perform_later(subscription) }
    end

    describe "#perform" do
      before do
        create(:mark, reader: membership, item: item_1, unread: true)
        create(:mark, reader: membership, item: item_2, unread: true)
      end

      it { expect { perform }.to change { Mark.count }.by(-2) }
      it { expect { perform }.to change { membership.reload.unread_count }.from(2).to(0) }
      it { expect { perform }.to change { Subscription.count }.by(-1) }
    end
  end
end
