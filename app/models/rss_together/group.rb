module RssTogether
  class Group < ApplicationRecord
    belongs_to :owner, class_name: "Account"

    has_one :group_transfer

    has_many :memberships, dependent: :destroy
    has_many :accounts, through: :memberships
    has_many :subscription_requests, through: :memberships

    has_many :subscriptions, dependent: :destroy
    has_many :feeds, through: :subscriptions
    has_many :items, through: :feeds

    has_many :invitations, dependent: :destroy

    validates :name, presence: true, length: { maximum: 64 }

    def initials
      name.split(" ").collect(&:first).join.upcase
    end
  end
end
