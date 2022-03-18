module RssTogether
  class NewSubscriptionRequestForm
    include ActiveModel::Model
    include ActiveModel::Validations
    include AfterCommitEverywhere

    attr_reader :membership, :subscription_request

    delegate :target_url, to: :subscription_request
    delegate :target_url=, to: :subscription_request
    delegate :group, to: :membership

    validate :already_subscribed, :subscription_request_is_valid

    def initialize(membership, params = {})
      @membership = membership
      @subscription_request = membership.subscription_requests.build
      super(params)
    end

    def submit
      raise ActiveRecord::RecordInvalid if invalid?

      ActiveRecord::Base.transaction do
        subscription_request.save!

        after_commit do
          if resolved_feed.present?
            SubscriptionRequestToSubscriptionJob.perform_later(subscription_request: subscription_request, feed: resolved_feed)
          else
            # ResolveNewFeedJob.perform_later(subscription_request: subscription_request)
          end
        end
      end

      true
    rescue ActiveRecord::RecordInvalid
      errors.merge!(subscription_request)
      false
    end

    private

    def already_subscribed
      errors.add(:target_url, "is already subscribed to") if group.feeds.exists?(link: subscription_request.target_url)
    end

    def subscription_request_is_valid
      errors.add(:subscription_request, "is invalid") if subscription_request.invalid?
    end

    def resolved_feed
      return @resolved_feed if @resolved_feed.present?

      similar_request = SubscriptionRequest.find_by(original_url: subscription_request.target_url)
      candidate_links = [subscription_request.target_url, similar_request&.target_url]

      @resolved_feed = Feed.find_by(link: candidate_links) || Feed.none
    end
  end
end
