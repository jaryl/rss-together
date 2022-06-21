module RssTogether
  class Recommendation < ApplicationRecord
    belongs_to :membership
    belongs_to :item

    has_one :group, through: :membership
    has_one :feed, through: :item
  end
end
