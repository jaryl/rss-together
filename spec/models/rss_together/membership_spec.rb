require 'rails_helper'

module RssTogether
  RSpec.describe Membership, type: :model do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:group) }
  end
end
