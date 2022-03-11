require 'rails_helper'

module RssTogether
  RSpec.describe GroupTransfer, type: :model do
    subject { build(:group_transfer) }

    it { is_expected.to belong_to :group }
    it { is_expected.to belong_to :recipient }

    it { expect(build(:group_transfer)).to be_valid }
    it { expect(build(:group_transfer, :invalid)).not_to be_valid }
  end
end
