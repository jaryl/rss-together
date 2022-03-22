module RssTogether
  class Groups::SubscriptionsController < Groups::BaseController
    include ActionView::Helpers::TextHelper

    before_action :prepare_group
    before_action :prepare_subscription, only: [:destroy]

    def index
      @subscriptions = policy_scope(@group.subscriptions.includes([:feed]))
    end

    def destroy
      @subscription.destroy
      flash[:success] = "Unsubscribed from #{truncate(@subscription.feed.title, length: 80)}"
      redirect_to group_subscriptions_path(@group), status: :see_other
    end

    def processing
      @subscription_requests = @group.subscription_requests
    end

    private

    def prepare_subscription
      @subscription = @group.subscriptions.find(params[:id])
      authorize @subscription
    end
  end
end
