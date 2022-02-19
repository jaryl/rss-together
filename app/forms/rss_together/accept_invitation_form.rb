module RssTogether
  class AcceptInvitationForm
    include ActiveModel::Model
    include ActiveModel::Validations

    validate :token_is_valid
    validate :membership_is_valid

    attr_accessor :display_name, :token
    attr_reader :account, :membership

    def initialize(account, params = {})
      @account = account
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
    end

    private

    def invitation
      # TODO: find should take into account expiry period
      @invitation ||= Invitation.find_by(token: token)
    end

    def group
      @group ||= invitation&.group
    end

    def token_is_valid
      errors.add(:token, "is invalid") if invitation.blank?
    end

    def membership_is_valid
      errors.add(:membership, "is invalid") if membership.invalid?
    end

    def membership_params
      {
        account: account,
        group: group,
        display_name: display_name,
      }
    end
  end
end
