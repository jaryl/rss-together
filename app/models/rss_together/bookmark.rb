module RssTogether
  class Bookmark < ApplicationRecord
    belongs_to :account
    belongs_to :item

    has_one :profile, through: :account

    counter_culture [:account, :profile]
  end
end
