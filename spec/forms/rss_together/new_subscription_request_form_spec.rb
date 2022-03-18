require 'rails_helper'

module RssTogether
  RSpec.describe NewSubscriptionRequestForm, type: :form do
    subject { described_class.new(membership, params) }

    let(:membership) { create(:membership) }
    let(:params) { {} }

    context "with valid params (without #resolved_feed)" do
      let(:params) { { target_url: Faker::Internet.url } }

      it { is_expected.to be_valid }
      it { expect { subject.submit }.to change { SubscriptionRequest.count }.by(1) }

      it "enqueues ResolveNewFeedJob" do
        ActiveJob::Base.queue_adapter = :test

        subject.submit

        # expect(ResolveNewFeedJob).to have_been_enqueued.with(subscription_request: subject.subscription_request)
        expect(SubscriptionRequestToSubscriptionJob).not_to have_been_enqueued
      end
    end

    context "with invalid params" do
      let(:params) { { target_url: "some-invalid-url" } }

      it { is_expected.not_to be_valid }
      it { expect { subject.submit }.not_to change { SubscriptionRequest.count } }
    end

    context "when #resolved_feed is resolved through #target_url" do
      let(:feed) { create(:feed) }
      let(:params) { { target_url: feed.link } }

      it "enqueues SubscriptionRequestToSubscriptionJob" do
        ActiveJob::Base.queue_adapter = :test

        subject.submit

        expect(SubscriptionRequestToSubscriptionJob).to have_been_enqueued.with(
          subscription_request: subject.subscription_request,
          feed: feed,
        )
        # expect(ResolveNewFeedJob).not_to have_been_enqueued
      end
    end

    context "when #resolved_feed is resolved through #similar_request" do
      let(:feed) { create(:feed) }
      let(:similar_request) { create(:subscription_request, target_url: Faker::Internet.url, target_url: feed.link) }
      let(:params) { { target_url: similar_request.original_url } }

      it "enqueues SubscriptionRequestToSubscriptionJob" do
        ActiveJob::Base.queue_adapter = :test

        subject.submit

        expect(SubscriptionRequestToSubscriptionJob).to have_been_enqueued.with(
          subscription_request: subject.subscription_request,
          feed: feed,
        )
        # expect(ResolveNewFeedJob).not_to have_been_enqueued
      end
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
