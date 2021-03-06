require 'rails_helper'

module RssTogether
  RSpec.describe Item, type: :model do
    it { is_expected.to belong_to(:feed) }

    it { is_expected.to have_many(:bookmarks) }
    it { is_expected.to have_many(:marks) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:recommendations) }

    it { is_expected.to validate_presence_of(:link) }

    it { expect(build(:item)).to be_valid }
    it { expect(build(:item, :invalid)).not_to be_valid }
  end
end
