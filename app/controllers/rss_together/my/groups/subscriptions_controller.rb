module RssTogether
  class My::Groups::SubscriptionsController < My::Groups::BaseController
    before_action :prepare_group

    def index
      @subscriptions = @group.subscriptions
    end

    def new
      @subscription = @group.subscriptions.build
    end

    def create
      @subscription = @group.subscriptions.build(subscription_params)
      if @subscription.save
        redirect_to my_group_subscriptions_path(@group)
      else
        render :new
      end
    end

    def destroy
      @subscription = @group.subscriptions.find(params[:id])
      @subscription.destroy
      redirect_to my_group_subscriptions_path(@group)
    end

    private

    def subscription_params
      params.require(:subscription).permit(:feed_id)
    end
  end
end
