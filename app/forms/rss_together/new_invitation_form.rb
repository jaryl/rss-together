module RssTogether
  class NewInvitationForm
    include ActiveModel::Model
    include ActiveModel::Validations
    include AfterCommitEverywhere

    MAX_GROUP_SIZE = 8

    validate :member_does_not_already_exist
    validate :invitation_already_sent
    validate :within_maximum_group_size
    validate :invitation_is_valid

    attr_accessor :email
    attr_reader :group, :sender, :invitation

    def initialize(group, sender, params = {})
      @group = group
      @sender = sender
      super(params)
      @invitation = group.invitations.build(email: self.email, sender: sender)
    end

    def submit
      raise ActiveRecord::RecordInvalid if invalid?

      ActiveRecord::Base.transaction do
        invitation.save!
        after_commit { GroupMailer.with(invitation: invitation).invitation_email.deliver_later }
      end

      invitation.persisted?
    rescue ActiveRecord::RecordInvalid
      errors.merge!(invitation)
      false
    end

    def limit_reached?
      group.accounts.size + group.invitations.size > MAX_GROUP_SIZE
    end

    private

    def member_does_not_already_exist
      existing_member = group.accounts.find_by(email: self.email)
      existing_invitation = group.invitations.find_by(email: self.email)
      errors.add(:base, "#{existing_member.email} is already part of the group") if existing_member.present?
    end

    def invitation_already_sent
      existing_invitation = group.invitations.find_by(email: self.email)
      errors.add(:base, "#{existing_invitation.email} has already been invited") if existing_invitation.present?
    end

    def within_maximum_group_size
      errors.add(:base, "You have reached the maximum group size") if limit_reached?
    end

    def invitation_is_valid
      errors.add(:invitation, "is invalid") if invitation.invalid?
    end
  end
end
