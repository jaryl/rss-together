module RssTogether
  module Reader
    class ReactionsController < BaseController
      before_action :prepare_group, :prepare_item
      before_action :prepare_reaction, only: [:show, :destroy]

      def show
        if @reaction.present?
          authorize @reaction
        else
          skip_authorization
        end
      end

      def edit
        @reaction = current_membership.reactions.find_or_initialize_by(item: @item)
        authorize @reaction
      end

      def update
        @reaction = current_membership.reactions.find_or_initialize_by(item: @item)
        authorize @reaction

        if @reaction.update(reaction_params)
          redirect_to reader_group_item_reaction_path(@group, @item), status: :see_other
        else
          render :show, status: :unprocessable_entity
        end
      end

      def destroy
        @reaction = current_membership.reactions.find_by(item: @item)

        if @reaction.present?
          authorize @reaction
          @reaction.destroy!
        else
          skip_authorization
        end

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
