require 'rails_helper'

module RssTogether
  RSpec.describe Profile, type: :model do
    it { is_expected.to belong_to(:account) }

    it { is_expected.to validate_presence_of(:display_name) }
    it { is_expected.to validate_length_of(:display_name).is_at_most(32).is_at_least(2) }

    it { is_expected.to validate_numericality_of(:recommendation_threshold).only_integer.is_greater_than(0).is_less_than_or_equal_to(3) }

    it { is_expected.to validate_presence_of(:timezone) }
    it { is_expected.to validate_inclusion_of(:timezone).in_array(ActiveSupport::TimeZone.all.map(&:name)) }

    it { expect(build(:profile)).to be_valid }
    it { expect(build(:profile, :invalid)).not_to be_valid }
  end
end
