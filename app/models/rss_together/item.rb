module RssTogether
  class Item < ApplicationRecord
    belongs_to :feed
    has_many :bookmarks

    validates :title, :description, :url, presence: true
  end
end
