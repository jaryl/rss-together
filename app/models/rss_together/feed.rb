module RssTogether
  class Feed < ApplicationRecord
    has_many :items
    has_many :subscriptions
    has_many :groups, through: :subscriptions

    validates :url, presence: true
  end
end
