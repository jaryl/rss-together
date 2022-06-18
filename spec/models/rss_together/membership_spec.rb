require 'rails_helper'

module RssTogether
  RSpec.describe Membership, type: :model do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:group) }

    it { is_expected.to have_one(:group_transfer) }
    it { is_expected.to have_one(:profile) }

    it { is_expected.to have_many(:subscription_requests) }
    it { is_expected.to have_many(:invitations) }
    it { is_expected.to have_many(:marks) }
    it { is_expected.to have_many(:recommendations) }
    it { is_expected.to have_many(:comments) }

    it { is_expected.to validate_length_of(:display_name_override).is_at_most(32).is_at_least(2) }
    it { is_expected.to validate_numericality_of(:recommendation_threshold_override).only_integer.is_greater_than(0).is_less_than_or_equal_to(3) }

    it { expect(build(:membership)).to be_valid }
    it { expect(build(:membership, :invalid)).not_to be_valid }
  end
end
