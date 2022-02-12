require 'rails_helper'

module RssTogether
  RSpec.describe Bookmark, type: :model do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:item) }

    it { expect(build(:bookmark)).to be_valid }
    it { expect(build(:bookmark, :invalid)).not_to be_valid }
  end
end
