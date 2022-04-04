module RssTogether
  class BookmarksController < ApplicationController
    before_action :prepare_bookmark, only: [:show, :destroy]

    def index
      @bookmarks = policy_scope(current_account.bookmarks)
    end

    def show
    end

    def destroy
      @bookmark.destroy!
      redirect_to bookmarks_path, status: :see_other
    end

    private

    def prepare_bookmark
      @bookmark = current_account.bookmarks.find(params[:id])
      authorize @bookmark
    end
  end
end
