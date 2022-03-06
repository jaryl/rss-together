require 'rails_helper'

module RssTogether
  RSpec.describe NewSubscriptionForm, type: :form do
    subject { described_class.new(account, group, params) }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:params) { {} }

    it { is_expected.to validate_url_of(:url) }
  end
end
