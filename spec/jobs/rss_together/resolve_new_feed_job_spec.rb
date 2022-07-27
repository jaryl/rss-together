require 'rails_helper'

module RssTogether
  RSpec.describe ResolveNewFeedJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    subject(:job) { described_class.perform_later(subscription_request, 0) }

    let(:subscription_request) { create(:subscription_request) }

    let(:mock_probe) { UrlProbe.new(url: subscription_request.target_url, document: mock_document) }
    let(:probe_target_url) { allow(UrlProbe).to receive(:from).and_return(mock_probe) }

    let(:perform) do
      allow(ProcessFeedAndItemsService).to receive(:call).and_return({ feed: feed })
      perform_enqueued_jobs(except: [MarkSubscriptionItemsAsUnreadJob]) { job }
    end

    context "with valid feed at target_url" do
      let(:feed) { create(:feed, link: subscription_request.target_url) }
      let(:mock_document) { double("document", atom?: true) }

      before { allow(mock_probe).to receive(:valid_feed_found).and_yield }
      before { probe_target_url; perform }

      it { expect(mock_probe).to have_received(:valid_feed_found) }
      it { expect(subscription_request.reload).to be_success }
      it { expect(MarkSubscriptionItemsAsUnreadJob).to have_been_enqueued }
    end

    context "with link to follow" do
      let(:feed) { create(:feed) }
      let(:mock_document) { double("document", atom?: false, rss?: false, link_to_feed: feed.link) }

      before { allow(mock_probe).to receive(:next_feed_found).and_yield }
      before { probe_target_url; perform }

      it { expect(mock_probe).to have_received(:next_feed_found).at_least(:once) }
      it { expect(subscription_request.reload).to be_failure }
      it { expect(subscription_request.reload.target_url).to eq(feed.link) }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
    end

    context "when no feed found" do
      let(:feed) { Feed.none }
      let(:mock_document) { double("document", atom?: false, rss?: false, link_to_feed: nil) }

      before { allow(mock_probe).to receive(:no_feed_found).and_yield }
      before { probe_target_url; perform }

      it { expect(mock_probe).to have_received(:no_feed_found) }
      it { expect(subscription_request.reload).to be_failure }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
    end

    context "on error raised" do
      describe "Faraday::Error" do
        let(:feed) { create(:feed) }
        before { allow(UrlProbe).to receive(:from).and_raise(Faraday::Error) }

        before { perform }

        it { expect(subscription_request.reload).to be_failure }
        it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
      end

      describe "NoFeedAtTargetUrlError" do
        let(:feed) { Feed.none }
        let(:mock_document) { double("document", atom?: false, rss?: false, link_to_feed: nil) }

        before { allow(mock_probe).to receive(:no_feed_found).and_yield }
        before { probe_target_url; perform }

        it { expect(mock_probe).to have_received(:no_feed_found) }
        it { expect(subscription_request.reload).to be_failure }
        it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
      end

      describe "DocumentParsingError" do
        let(:feed) { create(:feed) }

        before { allow(UrlProbe).to receive(:from).and_raise(DocumentParsingError) }
        before { perform }

        it { expect(subscription_request.reload).to be_failure }
        it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
      end
    end
  end
end
