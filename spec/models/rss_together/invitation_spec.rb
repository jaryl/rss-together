require 'rails_helper'

module RssTogether
  RSpec.describe Invitation, type: :model do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to have_one(:account) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_most(512) }

    it { expect(build(:invitation)).to be_valid }
    it { expect(build(:invitation, :invalid)).not_to be_valid }
  end
end
