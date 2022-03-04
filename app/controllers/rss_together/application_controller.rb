module RssTogether
  class ApplicationController < ::ApplicationController
    def current_account
      Account.first
    end
  end
end
