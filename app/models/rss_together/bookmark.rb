module RssTogether
  class Bookmark < ApplicationRecord
    belongs_to :account
    belongs_to :item
  end
end
