module RssTogether
  class GroupTransfer < ApplicationRecord
    belongs_to :group
    belongs_to :recipient, class_name: "Membership"

    def expired?
      created_at < RssTogether.group_transfers_expire_after.ago
    end
  end
end
