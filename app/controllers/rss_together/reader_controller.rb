module RssTogether
  class ReaderController < ApplicationController
    layout "reader"

    before_action :skip_authorization

    before_action :prepare_group, :prepare_item
    before_action :redirect_if_not_onboarded, only: [:show, :bookmarks]
    before_action :redirect_if_no_group_id, only: [:show]

    def show
    end

    def bookmarks
    end

    private

    def prepare_group
      @group = current_account.groups.find(params[:group_id]) if params[:group_id].present?
    end

    def prepare_item
      # TODO: feed_id needs to be in at least one group's subscription
      @item = Item.find(params[:item_id]) if params[:item_id].present?
    end

    def redirect_if_not_onboarded
      # redirect_to onboarding_path if currrent_account.groups.empty?
    end

    def redirect_if_no_group_id
      return if params[:group_id].present?
      redirect_to reader_path(group_id: current_account.groups.first.id) if current_account.groups.present?
    end
  end
end
