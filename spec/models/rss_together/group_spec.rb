require 'rails_helper'

module RssTogether
  RSpec.describe Group, type: :model do
    it { is_expected.to belong_to(:owner) }

    it { is_expected.to have_one(:group_transfer) }

    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:accounts).through(:memberships) }
    it { is_expected.to have_many(:subscription_requests).through(:memberships) }
    it { is_expected.to have_many(:recommendations).through(:memberships) }

    it { is_expected.to have_many(:subscriptions) }
    it { is_expected.to have_many(:feeds).through(:subscriptions) }
    it { is_expected.to have_many(:items).through(:feeds) }

    it { is_expected.to have_many(:invitations) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(64) }

    it { expect(build(:group)).to be_valid }
    it { expect(build(:group, :invalid)).not_to be_valid }
  end
end
