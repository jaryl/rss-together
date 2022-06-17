module RssTogether
  class Recommendation < ApplicationRecord
    belongs_to :membership
    belongs_to :item
  end
end
