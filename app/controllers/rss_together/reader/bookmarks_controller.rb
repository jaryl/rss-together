module RssTogether
  module Reader
    class BookmarksController < BaseController
      before_action :prepare_group, :prepare_item

      def show
        @bookmark = current_account.bookmarks.find_by(item: @item)
      end

      def create
        @bookmark = current_account.bookmarks.find_or_initialize_by(item: @item)
        if @bookmark.save
          redirect_to reader_group_item_bookmark_path(@group, @item), status: :see_other
        else
          render :show
        end
      end

      def destroy
        @bookmark = Bookmark.find_by(account: current_account, item: @item)
        @bookmark.destroy if @bookmark.present?
        render :show
      end
    end
  end
end
