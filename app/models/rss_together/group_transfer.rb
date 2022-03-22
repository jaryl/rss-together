module RssTogether
  class GroupTransfer < ApplicationRecord
    GROUP_TRANSFER_VALIDITY = 48.hours.freeze

    belongs_to :group
    belongs_to :recipient, class_name: "Membership"

    def expired?
      created_at < GROUP_TRANSFER_VALIDITY.ago
    end
  end
end
