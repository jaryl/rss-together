class Admin::RodauthController < ApplicationController
  # used by Rodauth for rendering views, CSRF protection, and running any
  # registered action callbacks and rescue_from handlers
  layout "basic"

  before_action :skip_authorization
  before_action :skip_policy_scope
end
