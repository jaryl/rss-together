module RssTogether
  class GroupTransferForm
    include ActiveModel::Model
    include ActiveModel::Validations
    include AfterCommitEverywhere

    validate :group_transfer_is_valid
    validate :recipient_is_present
    validate :cannot_transfer_group_to_self

    attr_accessor :recipient_id
    attr_reader :group, :transfer

    def initialize(group, params = {})
      @group = group
      super(params)
      @transfer = group.build_group_transfer(group_transfer_params)
    end

    def submit
      raise ActiveRecord::RecordInvalid if invalid?

      ActiveRecord::Base.transaction do
        transfer.save!
        after_commit { GroupMailer.with(transfer: transfer).transfer_email.deliver_later }
      end

      true
    rescue ActiveRecord::RecordInvalid
      errors.merge!(transfer)
      false
    rescue ActiveRecord::StatementInvalid
      errors.add(:base, "Something went wrong")
      false
    end

    def options_for_recipients
      group.memberships.reject { |membership| membership.account == group.owner }
    end

    private

    def group_transfer_is_valid
      errors.add(:transfer, "is invalid") if transfer.invalid?
    end

    def recipient_is_present
      errors.add(:receipient_id, "does not exist") if recipient.blank?
    end

    def cannot_transfer_group_to_self
      return if recipient.blank?
      errors.add(:recipient_id, "cannot be the owner") if recipient.account == group.owner
    end

    def recipient
      @recipient ||= group.memberships.find_by(id: recipient_id)
    end

    def group_transfer_params
      { recipient_id: recipient_id }
    end
  end
end
