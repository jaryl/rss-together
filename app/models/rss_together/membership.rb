module RssTogether
  class Membership < ApplicationRecord
    belongs_to :account
    belongs_to :group

    has_one :group_transfer, foreign_key: "recipient_id"
    has_one :profile, through: :account

    has_many :subscription_requests, dependent: :destroy
    has_many :invitations, foreign_key: "sender_id", dependent: :destroy
    has_many :marks, foreign_key: "reader_id", dependent: :destroy
    has_many :recommendations, dependent: :destroy
    has_many :comments, foreign_key: "author_id", dependent: :destroy

    validates :display_name_override, length: { minimum: 2, maximum: 32 }, allow_blank: true
    validates :recommendation_threshold_override, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 3, allow_nil: true }

    def display_name
      display_name_override.present? ? display_name_override : profile&.display_name
    end

    def recommendation_threshold
      recommendation_threshold_override.present? ? recommendation_threshold_override : profile&.recommendation_threshold
    end
  end
end
