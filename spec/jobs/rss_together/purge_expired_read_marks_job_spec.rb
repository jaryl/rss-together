require 'rails_helper'

module RssTogether
  RSpec.describe PurgeExpiredReadMarksJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:expired_mark) { create(:mark, unread: false, created_at: 2.months.ago) }
    let(:expired_unread_mark) { create(:mark, created_at: 2.months.ago) }
    let(:fresh_mark) { create(:mark, unread: false, created_at: 2.days.ago) }

    let(:perform) do
      perform_enqueued_jobs { described_class.perform_later }
    end

    before do
      expired_mark
      expired_unread_mark
      fresh_mark
      perform
    end

    it { expect { expired_mark.reload } .to raise_error(ActiveRecord::RecordNotFound) }
    it { expect(expired_unread_mark.reload).not_to be_destroyed }
    it { expect(fresh_mark.reload).not_to be_destroyed }
  end
end
