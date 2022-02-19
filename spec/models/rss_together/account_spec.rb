require 'rails_helper'

module RssTogether
  RSpec.describe Account, type: :model do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:groups).through(:memberships) }

    it { is_expected.to have_many(:bookmarks) }
    it { is_expected.to have_many(:comments) }

    it { is_expected.to have_many(:owned_groups) }
    it { is_expected.to have_many(:sent_invitations) }

    it { expect(build(:account)).to be_valid }
    it { expect(build(:account, :invalid)).not_to be_valid }
  end
end
