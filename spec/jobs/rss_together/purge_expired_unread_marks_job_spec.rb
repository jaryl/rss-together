require 'rails_helper'

module RssTogether
  RSpec.describe PurgeExpiredUnreadMarksJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:expired_user_mark) { create(:mark, source: :user, created_at: 2.months.ago) }
    let(:fresh_user_mark) { create(:mark, source: :user, created_at: 2.days.ago) }

    let(:expired_system_mark) { create(:mark, source: :system, created_at: 2.months.ago) }
    let(:fresh_system_mark) { create(:mark, source: :system, created_at: 2.days.ago) }

    let(:perform) do
      perform_enqueued_jobs { described_class.perform_later }
    end

    before do
      expired_user_mark
      fresh_user_mark
      expired_system_mark
      fresh_system_mark
      perform
    end

    it { expect { expired_user_mark.reload } .to raise_error(ActiveRecord::RecordNotFound) }
    it { expect(fresh_user_mark.reload).not_to be_destroyed }

    it { expect { expired_system_mark.reload } .to raise_error(ActiveRecord::RecordNotFound) }
    it { expect(fresh_system_mark.reload).not_to be_destroyed }

  end
end
