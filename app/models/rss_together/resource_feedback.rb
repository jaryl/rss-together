module RssTogether
  class ResourceFeedback < ApplicationRecord
    belongs_to :resource, polymorphic: true

    validates :title, :message, presence: true
  end
end
