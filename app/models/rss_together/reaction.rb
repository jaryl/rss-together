module RssTogether
  class Reaction < ApplicationRecord
    belongs_to :membership
    belongs_to :item

    validates :value, presence: true, inclusion: { in: %w(like happy wow sad dislike) }
  end
end
