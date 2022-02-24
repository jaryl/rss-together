module RssTogether
  module Reader
    class ReactionsController < BaseController
      before_action :prepare_group, :prepare_item
      before_action :prepare_reaction, only: [:show, :destroy]

      def show
      end

      def edit
        @reaction = current_membership.reactions.find_or_initialize_by(item: @item)
      end

      def update
        @reaction = current_membership.reactions.find_or_initialize_by(item: @item)
        @reaction.attributes = reaction_params
        if @reaction.save
          redirect_to reader_group_item_reaction_path(@group, @item)
        else
          render :show
        end
      end

      def destroy
        @reaction = current_membership.reactions.find_by(item: @item)
        @reaction.destroy if @reaction.present?
        render :show
      end

      private

      def prepare_reaction
        @reaction = current_membership.reactions.find_by(item: @item)
      end

      def reaction_params
        params.require(:reaction).permit(:value)
      end
    end
  end
end
