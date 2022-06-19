module RssTogether
  class Profile < ApplicationRecord
    belongs_to :account

    has_many :bookmarks, through: :account

    validates :display_name, presence: true, length: { minimum: 2, maximum: 32 }
    validates :recommendation_threshold, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 3, allow_nil: true }
    validates :timezone, presence: true, inclusion: { in: TZInfo::Timezone.all_identifiers }

    before_validation :retrieve_timezone_name

    def initials
      display_name.split(" ").collect(&:first).join.upcase
    end

    private

    def retrieve_timezone_name
      TZInfo::Timezone.get(timezone)
    rescue TZInfo::InvalidTimezoneIdentifier
      self.timezone = ActiveSupport::TimeZone::MAPPING.find { |key, value| key == self.timezone }&.last
    end
  end
end
