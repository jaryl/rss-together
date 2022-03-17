require "rails_helper"

module RssTogether
  RSpec.describe SubscriptionRequestPolicy, type: :policy do
    let(:user) { build_stubbed(:account) }

    subject { described_class }

    permissions ".scope" do
      pending "add some examples to (or delete) #{__FILE__}"
    end

    permissions :show? do
      pending "add some examples to (or delete) #{__FILE__}"
    end

    permissions :create? do
      pending "add some examples to (or delete) #{__FILE__}"
    end

    permissions :update? do
      pending "add some examples to (or delete) #{__FILE__}"
    end

    permissions :destroy? do
      pending "add some examples to (or delete) #{__FILE__}"
    end
  end
end

