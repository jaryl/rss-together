module RssTogether
  module Reader
    class RecommendationsController < BaseController
      include AfterCommitEverywhere

      before_action :prepare_group, :prepare_item
      before_action :prepare_recommendation, only: [:show, :destroy]

      def show
        @recommendation.present? ? authorize(@recommendation) : skip_authorization
      end

      def create
        @recommendation = current_membership.recommendations.find_or_initialize_by(item: @item)
        authorize @recommendation

        ActiveRecord::Base.transaction do
          @recommendation.save!
          after_commit { MarkRecommendedItemAsUnreadJob.perform_later(@recommendation) }
        end

        flash[:success] = "Recommended"
        redirect_to reader_group_item_recommendation_path(@group, @item), status: :see_other
      end

      def destroy
        @recommendation.present? ? authorize(@recommendation) : skip_authorization

        @recommendation.destroy! if @recommendation.present?

        flash[:success] = "Recommendation removed"
        redirect_to reader_group_item_recommendation_path(@group, @item), status: :see_other
      end

      private

      def prepare_recommendation
        @recommendation = current_membership.recommendations.find_by(item: @item)
      end
    end
  end
end
