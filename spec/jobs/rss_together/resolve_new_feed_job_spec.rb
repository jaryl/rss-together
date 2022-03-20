require 'rails_helper'

module RssTogether
  RSpec.describe ResolveNewFeedJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:subscription_request) { create(:subscription_request) }
    let(:feed) { Feed.none }

    let(:mock_document) { double("document") }
    let(:mock_probe) { double("probe", document: mock_document, atom?: false, rss?: false, link_to_feed: nil) }

    let(:probe_target_url) { allow(UrlProbe).to receive(:from).and_return(mock_probe) }
    let(:process_feed_and_items) { allow(ProcessFeedAndItemsService).to receive(:call).and_return({ feed: feed }) }

    let(:perform) do
      perform_enqueued_jobs(except: [MarkSubscriptionItemsAsUnreadJob]) do
        described_class.perform_later(
          subscription_request: subscription_request,
          follows: 0,
        )
      end
    end

    before do
      feed
      probe_target_url
      process_feed_and_items
      perform
    end

    context "with valid feed at target_url" do
      let(:feed) { create(:feed, link: subscription_request.target_url) }
      let(:mock_probe) { double("probe", document: mock_document, atom?: true) }

      it { expect(subscription_request.reload).to be_success }
      it { expect(MarkSubscriptionItemsAsUnreadJob).to have_been_enqueued }
    end

    context "with NoFeedAtTargetUrlError" do
      it { expect(subscription_request.reload).to be_failure }
      pending "check that resource feedback was created"
    end

    context "with link to follow" do
      let(:feed) { create(:feed) }
      let(:mock_probe) { double("probe", document: mock_document, atom?: false, rss?: false, link_to_feed: feed.link) }

      # Note: cannot implement mocks that change on subsequent runs of the job
      it { expect(subscription_request.reload.target_url).to eq(feed.link) }
    end

    context "with DocumentParsingError" do
      let(:probe_target_url) { allow(UrlProbe).to receive(:from).and_raise(DocumentParsingError) }

      it { expect(subscription_request.reload).to be_failure }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }

      pending "check that resource feedback was created"
    end

    context "with Faraday::Error" do
      let(:probe_target_url) { allow(UrlProbe).to receive(:from).and_raise(Faraday::Error) }

      it { expect(subscription_request.reload).to be_failure }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }

      pending "check that resource feedback was created"
    end
  end
end
