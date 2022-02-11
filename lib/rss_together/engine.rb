module RssTogether
  class Engine < ::Rails::Engine
    isolate_namespace RssTogether

    config.to_prepare do
    end

    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot dir: 'spec/factories'
      g.helper false
      g.assets false
      g.view_specs false
      g.request_specs false
      g.controller_specs true
    end
  end
end
