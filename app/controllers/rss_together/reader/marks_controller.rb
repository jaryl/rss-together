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
        @mark = current_membership.marks.find_or_initialize_by(item: @item) do |mark|
          mark.source = :user
        end
        authorize @mark

        if @mark.save
          flash[:success] = "Marked as unread"
          redirect_to reader_group_item_mark_path(@group, @item), status: :see_other
        else
          render :show
        end
      end

      def destroy
        @mark.destroy! if @mark.present?
        flash[:success] = "Marked as read"
        redirect_to reader_group_item_mark_path(@group, @item), status: :see_other
      end

      def all
        @marks = policy_scope(current_membership.marks)
        @affected_items = @marks.collect(&:item)

        ActiveRecord::Base.transaction do
          current_membership.marks.delete_all
          Membership.reset_counters(current_membership.id, :marks)
        end

        flash.now[:success] = "Marked all as read"
      end

      private

      def prepare_eager_loaded_item
        @item = Item.includes(marks: :reader).find(params[:item_id])
      end

      def prepare_mark
        @mark = current_membership.marks.find_by(item: @item)
        @mark.present? ? authorize(@mark) : skip_authorization
      end
    end
  end
end
