require 'rails_helper'

module RssTogether
  RSpec.describe EnqueueProcessFeedAndItemsJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:perform) do
      perform_enqueued_jobs(except: ProcessFeedAndItemsJob) do
        EnqueueProcessFeedAndItemsJob.perform_later
      end
    end

    before { feed; perform }

    context "with enabled feed that requires processing" do
      let(:feed) { create(:feed, :enabled, processed_at: 24.hours.ago) }
      describe "#perform" do
        it { expect(ProcessFeedAndItemsJob).to have_been_enqueued.with(feed: feed) }
      end
    end

    context "with enabled feed that is already processed" do
      let(:feed) { create(:feed, :enabled, processed_at: 1.hour.ago) }
      describe "#perform" do
        it { expect(ProcessFeedAndItemsJob).not_to have_been_enqueued.with(feed: feed) }
      end
    end

    context "with feed that is disabled" do
      let(:feed) { create(:feed, :disabled, processed_at: 24.hours.ago) }
      describe "#perform" do
        it { expect(ProcessFeedAndItemsJob).not_to have_been_enqueued.with(feed: feed) }
      end
    end
  end
end
