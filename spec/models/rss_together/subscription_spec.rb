require 'rails_helper'

module RssTogether
  RSpec.describe Subscription, type: :model do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:feed) }

    it { expect(build(:subscription)).to be_valid }
    it { expect(build(:subscription, :invalid)).not_to be_valid }
  end
end
