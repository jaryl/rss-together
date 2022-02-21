module RssTogether
  class ReaderController < ApplicationController
    def show
      @group_id = params[:group_id]
      @item_id = params[:item_id]
    end
  end
end
