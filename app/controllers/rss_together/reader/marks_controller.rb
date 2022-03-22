module RssTogether
  module Reader
    class MarksController < BaseController
      before_action :prepare_group, :prepare_item
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
        render :show
      end

      private

      def prepare_mark
        @mark = current_membership.marks.find_by(item: @item)
        @mark.present? ? authorize(@mark) : skip_authorization
      end
    end
  end
end
