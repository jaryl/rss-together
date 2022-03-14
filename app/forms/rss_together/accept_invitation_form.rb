module RssTogether
  class AcceptInvitationForm
    include ActiveModel::Model
    include ActiveModel::Validations

    validate :membership_is_valid

    attr_accessor :display_name
    attr_reader :account, :invitation, :membership

    def initialize(account, invitation, params = {})
      @account = account
      @invitation = invitation
      super(params)
      @membership = Membership.new(membership_params)
    end

    def submit
      raise ActiveRecord::RecordInvalid if invalid?

      ActiveRecord::Base.transaction do
        invitation.destroy!
        membership.save!
      end

      true
    rescue ActiveRecord::RecordInvalid
      errors.merge!(membership)
      false
    rescue ActiveRecord::StatementInvalid
      errors.add(:base, "Something went wrong")
      false
    end

    private

    def membership_is_valid
      errors.add(:membership, "is invalid") if membership.invalid?
    end

    def membership_params
      {
        account: account,
        group: invitation.group,
        display_name_override: display_name,
      }
    end
  end
end
