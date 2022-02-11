require "rails_helper"

module RssTogether
  RSpec.describe Feed, type: :model do
    it { should have_many(:items) }

    it { is_expected.to validate_presence_of(:url) }
  end
end
