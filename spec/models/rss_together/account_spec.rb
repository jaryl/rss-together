require 'rails_helper'

module RssTogether
  RSpec.describe Account, type: :model do
    it { is_expected.to have_one(:profile) }

    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:groups).through(:memberships) }

    it { is_expected.to have_many(:bookmarks) }
    it { is_expected.to have_many(:marks) }
    it { is_expected.to have_many(:comments) }

    it { is_expected.to have_many(:owned_groups) }
    it { is_expected.to have_many(:sent_invitations) }
    it { is_expected.to have_many(:group_transfers) }

    it { is_expected.to validate_presence_of(:email) }

    it { expect(build(:account)).to be_valid }
    it { expect(build(:account, :invalid)).not_to be_valid }
  end
end
