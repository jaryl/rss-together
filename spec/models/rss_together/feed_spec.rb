require "rails_helper"

module RssTogether
  RSpec.describe Feed, type: :model do
    it { should have_many(:items) }
    it { should have_many(:subscriptions) }
    it { should have_many(:groups).through(:subscriptions) }

    it { is_expected.to validate_presence_of(:url) }
  end
end
