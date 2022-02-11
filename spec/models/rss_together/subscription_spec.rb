require 'rails_helper'

module RssTogether
  RSpec.describe Subscription, type: :model do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:feed) }
  end
end
