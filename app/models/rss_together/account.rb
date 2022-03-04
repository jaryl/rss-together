module RssTogether
  class Account < ApplicationRecord
    has_many :memberships
    has_many :groups, through: :memberships
    has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy
    has_many :sent_invitations, class_name: "Invitation", foreign_key: "sender_id", dependent: :destroy
    has_many :marks
    has_many :bookmarks
    has_many :comments

    validates :email, presence: true
  end
end
