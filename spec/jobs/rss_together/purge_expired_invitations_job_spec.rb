require 'rails_helper'

module RssTogether
  RSpec.describe PurgeExpiredInvitationsJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:expired_invitation) { create(:invitation, created_at: 1.month.ago) }
    let(:fresh_invitation) { create(:invitation, created_at: 1.day.ago) }

    let(:perform) do
      perform_enqueued_jobs { described_class.perform_later }
    end

    before do
      expired_invitation
      fresh_invitation
      perform
    end

    it { expect { expired_invitation.reload } .to raise_error(ActiveRecord::RecordNotFound) }
    it { expect(fresh_invitation.reload).not_to be_destroyed }
  end
end
