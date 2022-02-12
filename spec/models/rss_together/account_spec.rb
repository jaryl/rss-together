require 'rails_helper'

module RssTogether
  RSpec.describe Account, type: :model do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:groups).through(:memberships) }

    it { expect(build(:account)).to be_valid }
    it { expect(build(:account, :invalid)).not_to be_valid }
  end
end
