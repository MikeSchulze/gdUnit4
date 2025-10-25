# -*- encoding: utf-8 -*-
# stub: sass-embedded 1.78.0 x86_64-linux-gnu lib

Gem::Specification.new do |s|
  s.name = "sass-embedded".freeze
  s.version = "1.78.0"
  s.platform = "x86_64-linux-gnu".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/sass-contrib/sass-embedded-host-ruby/issues", "documentation_uri" => "https://rubydoc.info/gems/sass-embedded/1.78.0", "funding_uri" => "https://github.com/sponsors/ntkme", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/sass-contrib/sass-embedded-host-ruby/tree/v1.78.0" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["\u306A\u3064\u304D".freeze]
  s.bindir = "exe".freeze
  s.date = "2024-09-03"
  s.description = "A Ruby library that will communicate with Embedded Dart Sass using the Embedded Sass protocol.".freeze
  s.email = ["i@ntk.me".freeze]
  s.executables = ["sass".freeze]
  s.files = ["exe/sass".freeze]
  s.homepage = "https://github.com/sass-contrib/sass-embedded-host-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "Use dart-sass with Ruby!".freeze

  s.installed_by_version = "3.4.19" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<google-protobuf>.freeze, ["~> 4.27"])
end
