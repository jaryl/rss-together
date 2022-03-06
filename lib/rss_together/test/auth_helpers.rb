module RssTogether
  module Test
    module AuthHelpers
      extend ActiveSupport::Concern

      def sign_in(account)
        request.env["rodauth"] = Rodauth::Rails.rodauth(account: account)
      end
    end
  end
end
