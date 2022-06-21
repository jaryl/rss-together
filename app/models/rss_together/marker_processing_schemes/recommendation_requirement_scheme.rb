module RssTogether
  module MarkerProcessingSchemes
    class RecommendationRequirementScheme
      attr_reader :membership

      def initialize(membership)
        @membership = membership
      end

      def process(item_ids)
        with_recommendation_counts(item_ids)
          .select { |_, count| count >= membership.recommendation_threshold }
          .keys
          .map do |item_id|
          {
            reader_id: membership.id,
            item_id: item_id,
          }
        end
      end

      private

      def with_recommendation_counts(item_ids)
        # This method returns [{ "item_id" => "count" }, ...]
        membership.group.recommendations.where(item_id: item_ids).group(:item_id).count
      end
    end
  end
end
