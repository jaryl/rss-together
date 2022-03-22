module RssTogether
  class Feed < ApplicationRecord
    has_many :items, dependent: :destroy
    has_many :subscriptions
    has_many :groups, through: :subscriptions

    has_many :feedback, as: :resource, class_name: "ResourceFeedback", dependent: :destroy

    validates :link, presence: true

    scope :enabled, -> { where(enabled: true) }
    scope :disabled, -> { where(enabled: false) }
  end
end
