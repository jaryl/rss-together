require 'rails_helper'

module RssTogether
  RSpec.describe ResourceFeedback, type: :model do
    it { is_expected.to belong_to(:resource) }

    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:message) }

    context do
      subject { build(:feedback) }
      it { is_expected.to validate_uniqueness_of(:key).scoped_to(:resource_type, :resource_id) }
    end

    it { expect(build(:feedback)).to be_valid }
    it { expect(build(:feedback, :invalid)).not_to be_valid }
  end
end
