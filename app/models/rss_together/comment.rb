module RssTogether
  class Comment < ApplicationRecord
    belongs_to :account
    belongs_to :item

    validates :content, presence: true
  end
end
