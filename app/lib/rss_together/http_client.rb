require "faraday/retry"
require "faraday/follow_redirects"

module RssTogether
  module HttpClient
    def self.conn
      Faraday.new do |connection|
        connection.request :retry # , { exceptions: [Faraday::ServerError, Faraday::NilStatusError] }
        connection.response :follow_redirects
      end
    end
  end
end
