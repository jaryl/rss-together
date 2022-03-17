require "rails_helper"

module RssTogether
  RSpec.describe SubscriptionRequest, type: :model do
    it { is_expected.to belong_to(:membership) }
    it { is_expected.to have_one(:group).through(:membership) }

    it { expect(build(:subscription_request)).to be_valid }
    it { expect(build(:subscription_request, :invalid)).not_to be_valid }
  end
end
