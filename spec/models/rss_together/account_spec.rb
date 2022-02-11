require 'rails_helper'

module RssTogether
  RSpec.describe Account, type: :model do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:groups).through(:memberships) }
  end
end
