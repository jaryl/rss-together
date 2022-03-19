require_relative "lib/rss_together/version"

Gem::Specification.new do |spec|
  spec.name        = "rss_together"
  spec.version     = RssTogether::VERSION
  spec.authors     = ["Jaryl Sim"]
  spec.email       = ["jaryl.sim@me.com"]
  spec.homepage    = "https://example.net"
  spec.summary     = "Lorem ipsum."
  spec.description = "Lorem ipsum."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.net"
  spec.metadata["changelog_uri"] = "https://example.net"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.2"
  spec.add_dependency "pg"
  spec.add_dependency "email_validator"
  spec.add_dependency "validate_url"
  spec.add_dependency "rss"
  spec.add_dependency "rodauth-rails", "~> 1.2"
  spec.add_dependency "pundit"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday-retry"
  spec.add_dependency "faraday-follow_redirects"


  spec.add_development_dependency "rspec-rails", "~> 5.0.0"
  spec.add_development_dependency "puma", "~> 5.2"
end
