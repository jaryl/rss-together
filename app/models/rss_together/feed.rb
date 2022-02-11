module RssTogether
  class Feed < ApplicationRecord
    has_many :items

    validates :url, presence: true
  end
end
