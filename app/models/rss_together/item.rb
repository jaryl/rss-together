module RssTogether
  class Item < ApplicationRecord
    belongs_to :feed

    validates :title, :description, :url, presence: true
  end
end
