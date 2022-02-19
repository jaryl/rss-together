module RssTogether
  class Account < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    has_many :memberships
    has_many :groups, through: :memberships
    has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy
    has_many :sent_invitations, class_name: "Invitation", foreign_key: "sender_id", dependent: :destroy
    has_many :bookmarks
    has_many :comments
  end
end
