module RssTogether
  class ApplicationController < ::ApplicationController
    before_action :authenticate_account!
  end
end
