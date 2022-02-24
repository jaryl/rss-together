require 'rails_helper'

module RssTogether
  RSpec.describe Reaction, type: :model do
    it { is_expected.to belong_to(:membership) }
    it { is_expected.to belong_to(:item) }

    it { is_expected.to validate_presence_of(:value) }

    it { expect(build(:reaction)).to be_valid }
    it { expect(build(:reaction, :invalid)).not_to be_valid }
  end
end
