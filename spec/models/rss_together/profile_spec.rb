require 'rails_helper'

module RssTogether
  RSpec.describe Profile, type: :model do
    it { is_expected.to belong_to(:account) }

    it { is_expected.to validate_presence_of(:display_name) }
    it { is_expected.to validate_presence_of(:timezone) }

    it { is_expected.to validate_inclusion_of(:timezone).in_array(ActiveSupport::TimeZone.all.map { |zone| zone.tzinfo.name }) }

    it { expect(build(:profile)).to be_valid }
    it { expect(build(:profile, :invalid)).not_to be_valid }
  end
end
