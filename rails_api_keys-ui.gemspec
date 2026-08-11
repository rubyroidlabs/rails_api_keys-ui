# frozen_string_literal: true

require_relative "lib/rails_api_keys/ui/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_api_keys-ui"
  spec.version     = RailsApiKeys::UI::VERSION
  spec.authors     = [ "Pavel Pershko" ]
  spec.email       = [ "pavel.pershko@rubyroidlabs.com" ]
  spec.homepage    = "https://github.com/rubyroidlabs/rails_api_keys-ui"
  spec.summary     = "Mountable HTML/JSON UI for rails_api_keys."
  spec.description = <<~DESC
    Optional Rails engine UI for rails_api_keys: draw helper for nested or flat
    mounts, HTML + JSON controller, scoped CSS + Stimulus defaults, and generators
    to copy controllers, views, and locales into the host app.
  DESC
  spec.license = "MIT"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "#{spec.homepage}/tree/v#{spec.version}",
    "changelog_uri" => "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "documentation_uri" => "https://www.rubydoc.info/gems/rails_api_keys-ui/#{spec.version}",
    "rubygems_mfa_required" => "true",
    "allowed_push_host" => "https://rubygems.org"
  }

  spec.files = Dir.chdir(__dir__) do
    Dir[
      "{app,config,lib}/**/*",
      "CHANGELOG.md",
      "LICENSE",
      "README.md"
    ].select { |f| File.file?(f) }
  end
  spec.extra_rdoc_files = [ "README.md", "CHANGELOG.md", "LICENSE" ]
  spec.require_paths = [ "lib" ]

  spec.required_ruby_version = ">= 3.2.0"
  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "rails_api_keys", ">= 0.2.0"
  spec.add_dependency "stimulus-rails", ">= 1.0"
end
