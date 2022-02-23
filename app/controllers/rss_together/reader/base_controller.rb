module RssTogether
  module Reader
    class BaseController < ApplicationController
      private

      def prepare_group
        @group = current_account.groups.find(params[:group_id])
      end

      def prepare_item
        @item = Item.find(params[:item_id])
      end
    end
  end
end
