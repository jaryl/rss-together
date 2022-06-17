require 'rails_helper'

module RssTogether
  RSpec.describe Recommendation, type: :model do
    it { is_expected.to belong_to(:membership) }
    it { is_expected.to belong_to(:item) }

    it { expect(build(:recommendation)).to be_valid }
    it { expect(build(:recommendation, :invalid)).not_to be_valid }
  end
end
