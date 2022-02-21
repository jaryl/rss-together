module RssTogether
  class Item < ApplicationRecord
    belongs_to :feed
    has_many :bookmarks
    has_many :comments

    validates :title, :description, :link, presence: true

    def preview
      @preview ||= Nokogiri::HTML(description).text
    end

    def website
      @website ||= URI.parse(link).host
    end
  end
end
