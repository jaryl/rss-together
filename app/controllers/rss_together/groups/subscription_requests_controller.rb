module RssTogether
  class Groups::SubscriptionRequestsController < Groups::BaseController
    before_action :prepare_group

    before_action :skip_authorization, only: [:processing]

    def new
      @form = NewSubscriptionRequestForm.new(current_membership)
      authorize @form.subscription_request
    end

    def create
      @form = NewSubscriptionRequestForm.new(current_membership, new_subscription_request_form_params)
      authorize @form.subscription_request
      if @form.submit
        flash[:success] = "Your new subscription will be available shortly"
        render :create
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :new, status: :unprocessable_entity
      end
    end

    def cancel
      @subscription_request = @group.subscription_requests.find(params[:id])
      authorize @subscription_request

      @subscription_request.destroy!

      flash[:success] = "Subscription request cancelled"
      redirect_to processing_group_subscriptions_path(@group), status: :see_other
    end

    def processing
      @subscription_requests = policy_scope(@group.subscription_requests)
    end

    private

    def new_subscription_request_form_params
      params.require(:new_subscription_request_form).permit(:target_url)
    end
  end
end
