module RssTogether
  class Account < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    has_many :memberships
    has_many :groups, through: :memberships
    has_many :bookmarks
    has_many :comments
  end
end
