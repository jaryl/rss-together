module RssTogether
  class Membership < ApplicationRecord
    belongs_to :account
    belongs_to :group

    has_one :group_transfer, foreign_key: "recipient_id"

    has_many :marks, foreign_key: "reader_id"
    has_many :reactions
    has_many :comments, foreign_key: "author_id"

    validates :display_name, length: { minimum: 2, maximum: 32 }, allow_blank: true
  end
end
