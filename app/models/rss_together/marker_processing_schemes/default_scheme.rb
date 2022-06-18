module RssTogether
  class MarkerProcessingSchemes::DefaultScheme
    attr_reader :membership

    def initialize(membership)
      @membership = membership
    end

    def process(item_ids)
      item_ids.map { |item_id| { item_id: item_id } }
    end
  end
end
