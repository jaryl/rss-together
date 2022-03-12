module RssTogether
  class Profile < ApplicationRecord
    belongs_to :account

    validates :display_name, :timezone, presence: true
    validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

    before_validation :retrieve_timezone_name

    def initials
      display_name.split(" ").collect(&:first).join.upcase
    end

    private

    def retrieve_timezone_name
      self.timezone = ActiveSupport::TimeZone::MAPPING.find { |key, value| key == timezone || value == timezone }&.first
    end
  end
end
