module RssTogether
  class Group < ApplicationRecord
    has_many :memberships
    has_many :accounts, through: :memberships
    has_many :subscriptions
    has_many :feeds, through: :subscriptions
    has_many :invitations

    validates :name, presence: true
  end
end
