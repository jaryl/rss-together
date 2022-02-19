module RssTogether
  class BookmarksController < ApplicationController
    def index
      @bookmarks = current_account.bookmarks
    end

    def show
      @bookmark = current_account.bookmarks.find(params[:id])
    end

    def destroy
      @bookmark = current_account.bookmarks.find(params[:id])
      @bookmark.destroy
      redirect_to bookmarks_path, status: :see_other
    end
  end
end
