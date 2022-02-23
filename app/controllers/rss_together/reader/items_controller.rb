module RssTogether
  module Reader
    class ItemsController < BaseController
      ITEM_LIMIT = 10

      before_action :prepare_group

      def index
        paginate_with_cursor do |query|
          @items = @group.items.order(published_at: :desc).limit(ITEM_LIMIT)
          @items = @items.where("published_at < ?", query[:published_at]) if query[:published_at].present?
        end
      end

      def show
        # TODO: move into a presenter
        @item = @group.items.find(params[:id])
        @bookmark = @item.bookmarks.find_by(account: current_account)
      end

      private

      def prepare_group
        @group = current_account.groups.find(params[:group_id])
      end

      def paginate_with_cursor
        @current_cursor = params[:cursor] || ""

        yield @current_cursor.blank? ? {} :deconstruct_cursor(@current_cursor)

        if @items.empty?
          @next_cursor = ""
        else
          @next_cursor = construct_cursor({
            published_at: @items.last.published_at,
          })
        end
      end

      def construct_cursor(params)
        Base64.encode64(params.to_json)
      end

      def deconstruct_cursor(cursor)
        JSON.parse(Base64.decode64(cursor)).with_indifferent_access
      end
    end
  end
end
