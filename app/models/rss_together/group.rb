module RssTogether
  class Group < ApplicationRecord
    belongs_to :owner, class_name: "Account"
    has_many :memberships, dependent: :destroy
    has_many :accounts, through: :memberships
    has_many :subscriptions, dependent: :destroy
    has_many :feeds, through: :subscriptions
    has_many :invitations, dependent: :destroy

    validates :name, presence: true
  end
end
