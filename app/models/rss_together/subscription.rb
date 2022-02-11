module RssTogether
  class Subscription < ApplicationRecord
    belongs_to :group
    belongs_to :feed
  end
end
