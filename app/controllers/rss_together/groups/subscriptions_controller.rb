module RssTogether
  class Groups::SubscriptionsController < Groups::BaseController
    before_action :prepare_group

    def index
      @subscriptions = @group.subscriptions
    end

    def new
      @form = NewSubscriptionForm.new(current_account, @group)
    end

    def create
      @form = NewSubscriptionForm.new(current_account, @group, new_subscription_form_params)
      if @form.submit
        redirect_to group_subscriptions_path(@group), status: :see_other
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @subscription = @group.subscriptions.find(params[:id])
      @subscription.destroy
      redirect_to group_subscriptions_path(@group), status: :see_other
    end

    private

    def subscription_params
      params.require(:subscription).permit(:feed_id)
    end

    def new_subscription_form_params
      params.require(:new_subscription_form).permit(:url)
    end
  end
end
