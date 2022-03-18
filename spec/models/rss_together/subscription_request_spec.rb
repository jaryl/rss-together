require "rails_helper"

module RssTogether
  RSpec.describe SubscriptionRequest, type: :model do
    it { is_expected.to belong_to(:membership) }
    it { is_expected.to have_one(:group).through(:membership) }
    it { is_expected.to have_one(:account).through(:membership) }

    context do
      subject { build(:subscription_request, original_url: Faker::Internet.url) }
      it { is_expected.to validate_uniqueness_of(:target_url).scoped_to(:membership_id) }
    end

    it { expect(build(:subscription_request)).to be_valid }
    it { expect(build(:subscription_request, :invalid)).not_to be_valid }
  end
end
