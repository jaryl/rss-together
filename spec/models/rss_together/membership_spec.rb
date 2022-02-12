require 'rails_helper'

module RssTogether
  RSpec.describe Membership, type: :model do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:group) }

    it { expect(build(:membership)).to be_valid }
    it { expect(build(:membership, :invalid)).not_to be_valid }
  end
end
