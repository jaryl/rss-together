require "faraday/retry"
require "faraday/follow_redirects"

module RssTogether
  module HttpClient
    USER_AGENT = "RssTogether".freeze

    def self.conn
      options = {
        headers: {
          "User-Agent": USER_AGENT,
        }
      }

      Faraday.new(nil, options) do |connection|
        connection.request :retry
        connection.response :follow_redirects
      end
    end
  end
end
