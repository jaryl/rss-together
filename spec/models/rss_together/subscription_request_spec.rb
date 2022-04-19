require "rails_helper"

module RssTogether
  RSpec.describe SubscriptionRequest, type: :model do
    it { is_expected.to belong_to(:membership) }

    it { is_expected.to have_one(:group).through(:membership) }
    it { is_expected.to have_one(:account).through(:membership) }

    it { is_expected.to have_many(:feedback) }

    it { is_expected.to validate_presence_of(:target_url) }
    it { is_expected.to validate_length_of(:target_url).is_at_most(2048) }

    it { expect(build(:subscription_request)).to be_valid }
    it { expect(build(:subscription_request, :invalid)).not_to be_valid }
  end
end
