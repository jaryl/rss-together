module RssTogether
  class Groups::SubscriptionsController < Groups::BaseController
    before_action :prepare_group
    before_action :prepare_subscription, only: [:destroy]

    def index
      @subscriptions = policy_scope(@group.subscriptions.includes([:feed]))
    end

    def new
      @form = NewSubscriptionRequestForm.new(current_membership)
      authorize @form.subscription_request
    end

    def create
      @form = NewSubscriptionRequestForm.new(current_membership, new_subscription_request_form_params)
      authorize @form.subscription_request
      if @form.submit
        flash[:success] = "Your new subscription will be available shortly"
        redirect_to group_subscriptions_path(@group), status: :see_other
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @subscription.destroy
      flash[:success] = "Subscription removed"
      redirect_to group_subscriptions_path(@group), status: :see_other
    end

    private

    def subscription_params
      params.require(:subscription).permit(:feed_id)
    end

    def new_subscription_request_form_params
      params.require(:new_subscription_request_form).permit(:target_url)
    end

    def prepare_subscription
      @subscription = @group.subscriptions.find(params[:id])
      authorize @subscription
    end
  end
end
