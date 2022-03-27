module RssTogether
  module Reader
    class BaseController < ApplicationController
      helper_method :current_group, :current_item, :current_membership

      private

      def current_group
        @current_group ||= current_account.groups.find_by(id: params[:group_id])
      end

      def current_item
        @current_item ||= Item.find_by(id: params[:item_id])
      end

      def current_membership
        @current_membership ||= current_account.memberships.find_by(group: current_group)
      end

      def prepare_group
        @group = current_account.groups.find(params[:group_id])
      end

      def prepare_item
        @item = Item.find(params[:item_id])
      end
    end
  end
end
