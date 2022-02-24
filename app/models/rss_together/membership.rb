module RssTogether
  class Membership < ApplicationRecord
    belongs_to :account
    belongs_to :group

    has_many :reactions

    validates :display_name, length: { minimum: 2, maximum: 32 }, allow_blank: true
  end
end
