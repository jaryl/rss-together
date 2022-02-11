module RssTogether
  class Engine < ::Rails::Engine
    isolate_namespace RssTogether

    config.to_prepare do
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
