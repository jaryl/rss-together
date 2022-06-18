module RssTogether
  module MarkerProcessingSchemes
    class RecommendationRequirementScheme
      attr_reader :membership

      def initialize(membership)
        @membership = membership
      end

      def process(item_ids)
        recommendation_counts = membership.recommendations.where(item_id: item_ids).group(:item_id).count
        results = recommendation_counts.select { |item_id, count| count >= membership.recommendation_threshold }.keys
        results.map { |item_id| { item_id: item_id } }
      end
    end
  end
end
