module RssTogether
  module Reader
    class MarksController < BaseController
      before_action :prepare_group
      before_action :prepare_item, only: [:create, :destroy]
      before_action :prepare_eager_loaded_item, only: [:show]
      before_action :prepare_mark, only: [:show, :destroy]

      def show
      end

      def create
        @mark = current_membership.marks.find_or_initialize_by(item: @item)
        authorize @mark

        @mark.source = :user
        @mark.unread = true

        if @mark.save
          flash[:success] = "Marked as unread"
          redirect_to reader_group_item_mark_path(@group, @item), status: :see_other
        else
          render :show
        end
      end

      def destroy
        @mark = current_membership.marks.find_or_initialize_by(item: @item)
        authorize @mark

        @mark.source = :user
        @mark.unread = false

        if @mark.save
          flash[:success] = "Marked as read"
          redirect_to reader_group_item_mark_path(@group, @item), status: :see_other
        else
          render :show
        end
      end

      def all
        @marks = policy_scope(current_membership.marks)
        affected_item_ids = @marks.collect(&:item_id)

        current_membership.with_lock do
          current_membership.marks.update_all(unread: false)
          current_membership.update!(unread_count: 0)
        end

        @affected_items = Item.includes(:marks).find(affected_item_ids)
        flash.now[:success] = "Marked all as read"
      end

      private

      def prepare_eager_loaded_item
        @item = Item.includes(:marks).find(params[:item_id])
      end

      def prepare_mark
        @mark = current_membership.marks.find_by(item: @item)
        @mark.present? ? authorize(@mark) : skip_authorization
      end
    end
  end
end
