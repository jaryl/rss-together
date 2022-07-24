require 'rails_helper'

module RssTogether
  RSpec.describe ResolveNewFeedJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    subject(:job) { described_class.perform_later(subscription_request, 0) }

    let(:subscription_request) { create(:subscription_request) }

    let(:mock_document) { double("document") }

    let(:probe_target_url) { allow(UrlProbe).to receive(:from).and_return(mock_probe) }
    let(:process_feed_and_items) { allow(ProcessFeedAndItemsService).to receive(:call).and_return({ feed: feed }) }

    let(:perform) do
      perform_enqueued_jobs(except: [MarkSubscriptionItemsAsUnreadJob]) { job }
    end

    before do
      feed
      probe_target_url
      process_feed_and_items
    end

    context "with valid feed at target_url" do
      let(:feed) { create(:feed, link: subscription_request.target_url) }
      let(:mock_probe) { double("probe", document: mock_document, atom?: true) }

      before { perform }

      it { expect(subscription_request.reload).to be_success }
      it { expect(MarkSubscriptionItemsAsUnreadJob).to have_been_enqueued }
    end

    context "with link to follow" do
      let(:feed) { create(:feed) }
      let(:mock_probe) { double("probe", document: mock_document, atom?: false, rss?: false, link_to_feed: feed.link) }

      before { perform }

      it { expect(subscription_request.reload).to be_failure }
      it { expect(subscription_request.reload.target_url).to eq(feed.link) }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
    end

    context "when Faraday::Error raised" do
      let(:feed) { create(:feed) }
      let(:probe_target_url) { allow(UrlProbe).to receive(:from).and_raise(Faraday::Error) }

      before { perform }

      it { expect(subscription_request.reload).to be_failure }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
    end

    context "when NoFeedAtTargetUrlError raised" do
      let(:feed) { Feed.none }
      let(:mock_probe) { double("probe", document: mock_document, atom?: false, rss?: false, link_to_feed: nil) }

      before { perform }

      it { expect(subscription_request.reload).to be_failure }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
    end

    context "when DocumentParsingError raised" do
      let(:feed) { create(:feed) }
      let(:probe_target_url) { allow(UrlProbe).to receive(:from).and_raise(DocumentParsingError) }

      before { perform }

      it { expect(subscription_request.reload).to be_failure }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
    end
  end
end
