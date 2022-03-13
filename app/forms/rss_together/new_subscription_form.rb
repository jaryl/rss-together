module RssTogether
  class NewSubscriptionForm
    include ActiveModel::Model
    include ActiveModel::Validations
    include AfterCommitEverywhere

    attr_accessor :url
    attr_reader :account, :group, :feed, :subscription

    validates :url, url: { no_local: true }, presence: true

    validate :already_subscribed

    def initialize(account, group, params = {})
      @account = account
      @group = group
      super(params)
      @subscription = group.subscriptions.build(feed: feed, account: account)
    end

    def submit
      raise ActiveRecord::RecordInvalid if invalid?

      ActiveRecord::Base.transaction do
        feed.save!
        subscription.save!
        after_commit { FeedProcessJob.perform_later(feed) }
      end

      true
    rescue ActiveRecord::RecordInvalid
      errors.merge!(subscription)
      false
    end

    private

    def feed
      return @feed if defined? @feed
      @feed = Feed.find_or_initialize_by(link: url)
    end

    def already_subscribed
      return if feed.new_record?
      errors.add(:url, "is already subscribed") if group.subscriptions.exists?(feed: feed)
    end
  end
end
