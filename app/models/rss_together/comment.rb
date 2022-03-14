module RssTogether
  class Comment < ApplicationRecord
    belongs_to :author, class_name: "Membership"
    belongs_to :item

    validates :content, presence: true
  end
end
