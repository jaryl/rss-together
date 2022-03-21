require "rails_helper"

module RssTogether
  RSpec.describe Feed, type: :model do
    it { should have_many(:items) }
    it { should have_many(:subscriptions) }
    it { should have_many(:groups).through(:subscriptions) }
    it { should have_many(:feedback) }

    it { is_expected.to validate_presence_of(:link) }

    it { expect(build(:feed)).to be_valid }
    it { expect(build(:feed, :invalid)).not_to be_valid }
  end
end
