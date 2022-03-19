module RssTogether
  class FeedElement
    include ActiveModel::Model

    attr_accessor :link, :title, :description, :language, :updated_at
  end
end
