require 'rails_helper'

module RssTogether
  RSpec.describe Mark, type: :model do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:item) }
  end
end
