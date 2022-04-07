module RssTogether
  module Reader
    class ItemsController < BaseController
      ITEM_LIMIT = 20

      before_action :prepare_group

      def index
        paginate_with_cursor do |query|
          @items = @group.items.order(published_at: :desc, title: :asc).limit(ITEM_LIMIT)
          @items = @items.where("published_at < ?", query[:published_at]) if query[:published_at].present?

          if "unread" == query[:filter]
            @items = @items.includes(:marks).where(marks: { reader_id: current_membership, unread: true })
          else
            @items = @items.includes(:marks)
          end
        end

        @items = policy_scope(@items)
      end

      def show
        # TODO: move into a presenter, display partials inline
        @item = Item.find(params[:id])
        authorize @item

        @bookmark = @item.bookmarks.find_by(account: current_account)
        @mark = @item.marks.find_by(reader: current_membership)
        @reaction = @item.reactions.find_by(membership: current_membership)
      end

      private

      def paginate_with_cursor
        # TODO: move into a paginator class/module
        @current_cursor = params[:cursor] || ""

        # TODO: improve handling of cursor params, validations for published_at, filter, etc
        current_params = @current_cursor.blank? ? { filter: params[:filter] || "all" } : deconstruct_cursor(@current_cursor)

        yield current_params

        if @items.empty?
          @next_cursor = ""
        else
          next_params = current_params.merge({
            published_at: @items.last.published_at,
            filter: params[:filter],
          }) { |key, oldval, newval| newval || oldval }

          @next_cursor = construct_cursor(next_params)
        end

        params.merge!(current_params)
      end

      def construct_cursor(params)
        Base64.urlsafe_encode64(params.to_json)
      end

      def deconstruct_cursor(cursor)
        JSON.parse(Base64.urlsafe_decode64(cursor)).with_indifferent_access
      end
    end
  end
end
