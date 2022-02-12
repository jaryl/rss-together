module RssTogether
  class Invitation < ApplicationRecord
    belongs_to :group
    validates :email, presence: true

    before_validation :generate_token, on: :create

    private

    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end
  end
end
