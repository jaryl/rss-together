require 'rails_helper'

module RssTogether
  RSpec.describe Comment, type: :model do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:item) }

    it { is_expected.to validate_presence_of(:content) }

    it { expect(build(:comment)).to be_valid }
    it { expect(build(:comment, :invalid)).not_to be_valid }
  end
end
