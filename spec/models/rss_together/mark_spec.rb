require 'rails_helper'

module RssTogether
  RSpec.describe Mark, type: :model do
    it { is_expected.to belong_to(:reader) }
    it { is_expected.to belong_to(:item) }
    it { is_expected.to have_one(:account).through(:reader) }

    it { expect(build(:mark)).to be_valid }
    it { expect(build(:mark, :invalid)).not_to be_valid }
  end
end
