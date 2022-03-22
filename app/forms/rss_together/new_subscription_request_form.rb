module RssTogether
  class NewSubscriptionRequestForm
    include ActiveModel::Model
    include ActiveModel::Validations
    include AfterCommitEverywhere

    attr_reader :membership, :subscription_request

    delegate :target_url, to: :subscription_request
    delegate :target_url=, to: :subscription_request
    delegate :group, to: :membership

    validate :already_subscribed, :already_in_flight, :subscription_request_is_valid

    def initialize(membership, params = {})
      @membership = membership
      @subscription_request = membership.subscription_requests.build
      super(params)
    end

    def submit
      raise ActiveRecord::RecordInvalid if invalid?

      if resolved_feed.blank?
        subscription_request.save!
        ResolveNewFeedJob.perform_later(subscription_request: subscription_request)
        return true
      end

      ActiveRecord::Base.transaction do
        subscription_request.save!

        CompleteSubscriptionRequestWithFeedService.call(
          subscription_request: subscription_request,
          feed: resolved_feed,
        ) => { subscription: }
      end

      true
    rescue ActiveRecord::RecordInvalid
      errors.merge!(subscription_request)
      false
    end

    private

    def already_subscribed
      urls_to_check = [subscription_request.target_url, resolved_feed&.link].reject(&:blank?)
      errors.add(:target_url, "is already subscribed to") if group.feeds.exists?(link: urls_to_check)
    end

    def already_in_flight
      errors.add(:target_url, "is already pending subscription") if group.subscription_requests.not_success.exists?(target_url: subscription_request.target_url)
    end

    def subscription_request_is_valid
      errors.add(:subscription_request, "is invalid") if subscription_request.invalid?
    end

    def resolved_feed
      return @resolved_feed if @resolved_feed.present?

      similar_request = SubscriptionRequest.find_by(original_url: subscription_request.target_url)
      candidate_links = [subscription_request.target_url, similar_request&.target_url]

      @resolved_feed = Feed.find_by(link: candidate_links)
    end
  end
end
