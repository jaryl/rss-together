module RssTogether
  class Membership < ApplicationRecord
    belongs_to :account
    belongs_to :group
  end
end
