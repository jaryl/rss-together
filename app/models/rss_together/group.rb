module RssTogether
  class Group < ApplicationRecord
    has_many :subscriptions
    has_many :feeds, through: :subscriptions

    validates :name, presence: true
  end
end
