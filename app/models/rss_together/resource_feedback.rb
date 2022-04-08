module RssTogether
  class ResourceFeedback < ApplicationRecord
    enum status: {
      pending: "pending",
      resolved: "resolved",
      dismissed: "dismissed",
    }

    belongs_to :resource, polymorphic: true

    validates :key, :message, presence: true
    validates :key, uniqueness: { scope: [:resource_type, :resource_id] }
  end
end
