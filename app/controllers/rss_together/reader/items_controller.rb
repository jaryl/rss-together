module RssTogether
  module Reader
    class ItemsController < BaseController
      before_action :prepare_group

      def index
        # TODO: retrieve only latest n items, pagination, etc
        @items = @group.items.order(published_at: :desc)
      end

      def show
        @item = @group.items.find(params[:id])
      end

      private

      def prepare_group
        @group = current_account.groups.find(params[:group_id])
      end
    end
  end
end
