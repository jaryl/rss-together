module RssTogether
  class Mark < ApplicationRecord
    belongs_to :reader, class_name: "Membership"
    belongs_to :item
    has_one :account, through: :reader
  end
end
