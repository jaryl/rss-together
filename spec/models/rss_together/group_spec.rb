require 'rails_helper'

module RssTogether
  RSpec.describe Group, type: :model do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:accounts).through(:memberships) }

    it { is_expected.to have_many(:subscriptions) }
    it { is_expected.to have_many(:feeds).through(:subscriptions) }

    it { is_expected.to have_many(:invitations) }

    it { is_expected.to validate_presence_of(:name) }
  end
end
