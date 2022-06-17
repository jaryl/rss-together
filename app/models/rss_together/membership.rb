module RssTogether
  class Membership < ApplicationRecord
    belongs_to :account
    belongs_to :group

    has_one :group_transfer, foreign_key: "recipient_id"

    has_many :subscription_requests, dependent: :destroy
    has_many :invitations, foreign_key: "sender_id", dependent: :destroy
    has_many :marks, foreign_key: "reader_id", dependent: :destroy
    has_many :recommendations, dependent: :destroy
    has_many :comments, foreign_key: "author_id", dependent: :destroy

    validates :display_name_override, length: { minimum: 2, maximum: 32 }, allow_blank: true

    def display_name
      display_name_override.present? ? display_name_override : account&.profile&.display_name
    end
  end
end
