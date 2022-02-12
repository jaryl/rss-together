require 'rails_helper'

module RssTogether
  RSpec.describe Comment, type: :model do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:item) }

    it { is_expected.to validate_presence_of(:content) }

    it { expect(build(:bookmark)).to be_valid }
    it { expect(build(:bookmark, :invalid)).not_to be_valid }
  end
end
