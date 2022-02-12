module RssTogether
  class BookmarksController < ApplicationController
    def index
      @bookmarks = current_account.bookmarks
    end

    def show
      @bookmark = current_account.bookmarks.find(params[:id])
    end
  end
end
