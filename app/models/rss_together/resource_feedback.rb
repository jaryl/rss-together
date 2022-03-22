module RssTogether
  class ResourceFeedback < ApplicationRecord
    belongs_to :resource, polymorphic: true

    validates :title, :message, presence: true
    validates :title, uniqueness: { scope: [:resource_type, :resource_id] }
  end
end
