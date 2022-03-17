module RssTogether
  class SubscriptionRequest < ApplicationRecord
    enum status: {
      pending: "pending",
      success: "success",
      failure: "failure",
    }

    belongs_to :membership
    has_one :group, through: :membership

    before_validation :preserve_original_url

    validates :target_url, url: { no_local: true }, presence: true

    private

    def preserve_original_url
      self.original_url = target_url
    end
  end
end
