module RssTogether
  class Settings::BaseController < ApplicationController
    after_action :verify_authorized, except: :index
    after_action :verify_policy_scoped, only: :index
  end
end
