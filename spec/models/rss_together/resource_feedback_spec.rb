require 'rails_helper'

module RssTogether
  RSpec.describe ResourceFeedback, type: :model do
    it { is_expected.to belong_to(:resource) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:message) }

    it { expect(build(:feedback)).to be_valid }
    it { expect(build(:feedback, :invalid)).not_to be_valid }
  end
end
