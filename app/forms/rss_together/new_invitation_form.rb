module RssTogether
  class NewInvitationForm
    include ActiveModel::Model
    include ActiveModel::Validations

    MAX_GROUP_SIZE = 8

    validate :member_does_not_already_exist
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
      if valid?
        invitation.save
      else
        errors.merge!(invitation)
      end
      invitation.persisted?
    end

    private

    def member_does_not_already_exist
      existing_member = group.accounts.find_by(email: self.email)
      errors.add(:base, "#{existing_member.email} is already part of the group") if existing_member.present?
    end

    def within_maximum_group_size
      total_count = group.accounts.size + group.invitations.size
      errors.add(:base, "You have reached the maximum group size") if total_count > MAX_GROUP_SIZE
    end

    def invitation_is_valid
      errors.add(:invitation, "is invalid") if invitation.invalid?
    end
  end
end
