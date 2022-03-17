require 'rails_helper'

module RssTogether
  RSpec.describe NewSubscriptionRequestForm, type: :form do
    subject { described_class.new(membership, params) }

    let(:membership) { create(:membership) }
    let(:params) { {} }

    context "with valid params" do
      let(:params) { { target_url: Faker::Internet.url } }

      it { is_expected.to be_valid }
      it { expect { subject.submit }.to change { SubscriptionRequest.count }.by(1) }
    end

    context "with invalid params" do
      let(:params) { { target_url: "some-invalid-url" } }

      it { is_expected.not_to be_valid }
      it { expect { subject.submit }.not_to change { SubscriptionRequest.count } }
    end

    context "when #resolved_feed is present" do
      pending
    end

    context "validations" do
      describe "#already_subscribed" do
        let(:target_url) { Faker::Internet.url }
        let(:feed) { create(:feed, link: target_url) }
        let(:params) { { target_url: target_url } }

        before { create(:subscription, group: membership.group, feed: feed) }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
