module RssTogether
  module Reader
    class MarksController < BaseController
      before_action :prepare_group, :prepare_item

      def show
        @mark = current_account.marks.find_by(item: @item)
      end

      def create
        @mark = current_account.marks.find_or_initialize_by(item: @item) do |mark|
          mark.source = :user
        end

        if @mark.save
          redirect_to reader_group_item_mark_path(@group, @item), status: :see_other
        else
          render :show
        end
      end

      def destroy
        @mark = Mark.find_by(account: current_account, item: @item)
        @mark.destroy if @mark.present?
        render :show
      end
    end
  end
end
