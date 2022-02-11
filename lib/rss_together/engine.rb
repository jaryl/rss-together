module RssTogether
  class Engine < ::Rails::Engine
    isolate_namespace RssTogether

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
