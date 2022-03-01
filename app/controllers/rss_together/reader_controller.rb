module RssTogether
  class ReaderController < ApplicationController
    layout "reader"

    def show
      @group_id = params[:group_id]
      @item_id = params[:item_id]
    end
  end
end
