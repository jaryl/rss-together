module RssTogether
  class Account < ApplicationRecord
    include Rodauth::Rails.model

    enum status: {
      unverified: "unverified",
      verified: "verified",
      closed: "closed",
    }

    has_one :profile
    has_many :memberships
    has_many :groups, through: :memberships
    has_many :subscriptions, through: :groups
    has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy
    has_many :sent_invitations, class_name: "Invitation", foreign_key: "sender_id", dependent: :destroy
    has_many :group_transfers, foreign_key: "recipient_id", dependent: :destroy
    has_many :bookmarks

    validates :email, presence: true, length: { maximum: 512 }, email: { mode: :strict }
  end
end
