module RssTogether
  class Mark < ApplicationRecord
    belongs_to :account
    belongs_to :item
  end
end
