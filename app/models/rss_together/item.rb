module RssTogether
  class Item < ApplicationRecord
    belongs_to :feed
    has_many :bookmarks
    has_many :comments

    validates :title, :description, :url, presence: true
  end
end
