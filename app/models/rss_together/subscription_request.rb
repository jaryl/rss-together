module RssTogether
  class SubscriptionRequest < ApplicationRecord
    enum status: {
      pending: "pending",
      success: "success",
      failure: "failure",
    }

    belongs_to :membership
    has_one :group, through: :membership
    has_one :account, through: :membership

    before_validation :preserve_original_url

    validates :target_url, url: { no_local: true }, presence: true

    validates :target_url, uniqueness: { scope: :membership_id } # TODO: limit uniqueness only to pending requests

    private

    def preserve_original_url
      self.original_url ||= target_url
    end
  end
end
