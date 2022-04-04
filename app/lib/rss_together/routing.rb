module RssTogether
  class Routing
    attr_reader :admin_ids

    def self.admin
      new(ENV.fetch("ADMIN_IDS", "").split(",").map(&:strip))
    end

    def initialize(admin_ids)
      @admin_ids = admin_ids
    end

    def matches?(request)
      admin_ids.include?(request.env["rodauth"].logged_in?)
    end
  end
end
