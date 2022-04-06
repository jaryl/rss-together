module RssTogether
  class Subscription < ApplicationRecord
    belongs_to :group
    belongs_to :feed
    belongs_to :account

    def requires_processing?
      return true if processed_at.blank? || feed.processed_at.blank?
      self.processed_at < feed.processed_at
    end
  end
end
