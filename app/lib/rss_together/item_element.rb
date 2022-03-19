module RssTogether
  class ItemElement
    include ActiveModel::Model

    attr_accessor :title, :content, :link, :description, :author, :published_at, :guid, :updated_at, :categories
  end
end
