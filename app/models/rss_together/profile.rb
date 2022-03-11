module RssTogether
  class Profile < ApplicationRecord
    belongs_to :account

    validates :display_name, :timezone, presence: true
    validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

    def initials
      display_name.split(" ").collect(&:first).join.upcase
    end
  end
end
