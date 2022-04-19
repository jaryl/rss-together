module RssTogether
  class Invitation < ApplicationRecord
    belongs_to :group
    belongs_to :sender, class_name: "Membership"
    has_one :account, through: :sender

    validates :email, presence: true, length: { maximum: 512 }, email: { mode: :strict }

    before_validation :generate_token, on: :create

    private

    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end
  end
end
