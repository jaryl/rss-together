module RssTogether
  class GroupTransfer < ApplicationRecord
    belongs_to :group
    belongs_to :recipient, class_name: "Membership"
  end
end
