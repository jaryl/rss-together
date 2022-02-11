require 'rails_helper'

module RssTogether
  RSpec.describe Item, type: :model do
    it { is_expected.to belong_to(:feed) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:url) }
  end
end
