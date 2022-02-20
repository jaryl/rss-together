module RssTogether
  class Subscription < ApplicationRecord
    belongs_to :group
    belongs_to :feed
    belongs_to :account
  end
end
