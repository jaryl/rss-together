module RssTogether
  class Mark < ApplicationRecord
    enum source: {
      system: "system",
      user: "user",
    }, _suffix: true

    belongs_to :reader, class_name: "Membership"
    belongs_to :item

    has_one :account, through: :reader
    has_one :group, through: :reader

    scope :read, -> () { where(unread: false) }
    scope :unread, -> () { where(unread: true) }

    counter_culture :reader,
      column_name: proc { |model| model.unread? ? 'unread_count' : nil },
      column_names: {
        Mark.unread => 'unread_count',
      }
  end
end
