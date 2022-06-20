module RssTogether
  class Bookmark < ApplicationRecord
    MAX_BOOKMARKS = 99
    belongs_to :account
    belongs_to :item

    has_one :profile, through: :account

    counter_culture [:account, :profile]

    validate :does_not_execeed_max_limit

    private

    def does_not_execeed_max_limit
      return if profile.nil?
      errors.add(:base, "You've reached the maximum number of bookmarks") if profile.bookmarks_count >= MAX_BOOKMARKS
    end
  end
end
