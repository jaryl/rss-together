require 'rails_helper'

module RssTogether
  RSpec.describe ProcessFeedAndItemsJob, type: :job do
    before { ActiveJob::Base.queue_adapter = :test }
    after { clear_enqueued_jobs }

    let(:feed) { create(:feed) }
    let(:subscriptions) { create_list(:subscription, 2, feed: feed) }

    let(:mock_response) { double("response", body: "<feed>Hello World</feed>") }
    let(:mock_connection) { double("conn", get: mock_response) }

    let(:make_get_request) { allow(HttpClient).to receive(:conn).and_return(mock_connection) }
    let(:parse_document) { allow(XmlDocument).to receive(:with) }
    let(:process_feed_and_items) { allow(ProcessFeedAndItemsService).to receive(:call).and_return({ feed: feed }) }

    let(:perform) do
      perform_enqueued_jobs(except: MarkSubscriptionItemsAsUnreadJob) do
        described_class.perform_later(feed)
      end
    end

    before do
      subscriptions
      make_get_request
      parse_document
      process_feed_and_items
      perform
    end

    context "with no errors" do
      context "with no subscriptions" do
        let(:subscriptions) { Subscription.none }
        it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
      end

      context "with some subscriptions" do
        it { expect(MarkSubscriptionItemsAsUnreadJob).to have_been_enqueued.exactly(2) }
      end
    end

    context "with Faraday::Error" do
      let(:mock_connection) do
        mock_connection = double
        mock_connection.tap { allow(mock_connection).to receive(:get).and_raise(Faraday::Error, "Faraday::Error") }
      end

      it { expect(feed.feedback).to be_present }

      it { expect(ProcessFeedAndItemsService).not_to receive(:call) }
      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
    end

    context "with DocumentParsingError" do
      let(:process_feed_and_items) { allow(ProcessFeedAndItemsService).to receive(:call).and_raise(DocumentParsingError) }

      it { expect(feed.feedback).to be_present }

      it { expect(MarkSubscriptionItemsAsUnreadJob).not_to have_been_enqueued }
    end
  end
end
