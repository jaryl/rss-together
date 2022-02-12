module RssTogether
  class Group < ApplicationRecord
    has_many :memberships, dependent: :destroy
    has_many :accounts, through: :memberships
    has_many :subscriptions, dependent: :destroy
    has_many :feeds, through: :subscriptions
    has_many :invitations, dependent: :destroy

    validates :name, presence: true
  end
end
