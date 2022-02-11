require 'rails_helper'

module RssTogether
  RSpec.describe Group, type: :model do
    it { is_expected.to validate_presence_of(:name) }
  end
end
