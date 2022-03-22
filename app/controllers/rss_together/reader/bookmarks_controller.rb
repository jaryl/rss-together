module RssTogether
  module Reader
    class BookmarksController < BaseController
      before_action :prepare_group, :prepare_item
      before_action :prepare_bookmark, only: [:show, :destroy]

      def show
      end

      def create
        @bookmark = current_account.bookmarks.find_or_initialize_by(item: @item)
        authorize @bookmark

        @bookmark.save!

        flash[:success] = "Bookmark saved"
        redirect_to reader_group_item_bookmark_path(@group, @item), status: :see_other
      end

      def destroy
        @bookmark.destroy! if @bookmark.present?

        flash[:success] = "Bookmark removed"
        render :show
      end

      private

      def prepare_bookmark
        @bookmark = current_account.bookmarks.find_by(item: @item)
        @bookmark.present? ? authorize(@bookmark) : skip_authorization
      end
    end
  end
end
