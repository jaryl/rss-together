module RssTogether
  module Test
    module AuthHelpers
      extend ActiveSupport::Concern

      def sign_in(account)
        RodauthApp.rodauth.login(login: account.email, password: "123123123")
        request.env["rodauth"] = Rodauth::Rails.rodauth(account: account)
      end
    end
  end
end
