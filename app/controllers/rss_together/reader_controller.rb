module RssTogether
  class ReaderController < ApplicationController
    layout "reader"

    before_action :prepare_group, :prepare_item

    def show
    end

    private

    def prepare_group
      @group = current_account.groups.find(params[:group_id]) if params[:group_id].present?
    end

    def prepare_item
      # TODO: feed_id needs to be in at least one group's subscription
      @item = Item.find(params[:item_id]) if params[:item_id].present?
    end
  end
end
