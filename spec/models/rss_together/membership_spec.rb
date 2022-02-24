require 'rails_helper'

module RssTogether
  RSpec.describe Membership, type: :model do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:group) }

    it { is_expected.to have_many(:reactions) }

    it { is_expected.to validate_length_of(:display_name).is_at_most(32).is_at_least(2) }

    it { expect(build(:membership)).to be_valid }
    it { expect(build(:membership, :invalid)).not_to be_valid }
  end
end
