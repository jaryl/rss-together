module RssTogether
  class Mark < ApplicationRecord
    enum source: {
      system: "system",
      user: "user",
    }, _suffix: true

    belongs_to :reader, class_name: "Membership", counter_cache: :unread_count
    belongs_to :item

    has_one :account, through: :reader

    scope :read, -> () { where(unread: false) }
    scope :unread, -> () { where(unread: true) }
  end
end
