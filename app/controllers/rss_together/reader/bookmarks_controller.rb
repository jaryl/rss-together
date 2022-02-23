module RssTogether
  module Reader
    class BookmarksController < BaseController
      before_action :prepare_group, :prepare_item

      def create
        @bookmark = current_account.bookmarks.find_or_create_by(item: @item)
        render :show
      end

      def destroy
        @bookmark = Bookmark.find_by(account: current_account, item: @item)
        @bookmark.destroy if @bookmark.present?
        render :show
      end
    end
  end
end
