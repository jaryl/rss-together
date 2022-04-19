require "faraday/retry"
require "faraday/follow_redirects"

module RssTogether
  module HttpClient
    def self.conn
      options = {
        headers: {
          "User-Agent": RssTogether.user_agent,
        },
        request: {
          open_timeout: 1,
          timeout: 1,
        },
      }

      Faraday.new(nil, options) do |connection|
        connection.request :retry
        connection.response :follow_redirects
      end
    end
  end
end
