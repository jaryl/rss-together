module RssTogether
  class Item < ApplicationRecord
    belongs_to :feed

    has_many :bookmarks
    has_many :marks
    has_many :comments
    has_many :recommendations

    validates :link, presence: true

    def website
      @website ||= Addressable::URI.parse(link).host
    end
  end
end
