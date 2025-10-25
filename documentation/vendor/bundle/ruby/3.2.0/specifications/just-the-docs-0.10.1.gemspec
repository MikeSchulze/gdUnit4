# -*- encoding: utf-8 -*-
# stub: just-the-docs 0.10.1 ruby lib

Gem::Specification.new do |s|
  s.name = "just-the-docs".freeze
  s.version = "0.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/just-the-docs/just-the-docs/issues", "changelog_uri" => "https://github.com/just-the-docs/just-the-docs/blob/main/CHANGELOG.md", "documentation_uri" => "https://just-the-docs.com/", "source_code_uri" => "https://github.com/just-the-docs/just-the-docs" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Patrick Marsceill".freeze, "Matthew Wang".freeze]
  s.date = "2025-01-06"
  s.email = ["patrick.marsceill@gmail.com".freeze, "matt@matthewwang.me".freeze]
  s.executables = ["just-the-docs".freeze]
  s.files = ["bin/just-the-docs".freeze]
  s.homepage = "https://github.com/just-the-docs/just-the-docs".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.19".freeze
  s.summary = "A modern, highly customizable, and responsive Jekyll theme for documentation with built-in search.".freeze

  s.installed_by_version = "3.4.19" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, [">= 2.3.5"])
  s.add_runtime_dependency(%q<jekyll>.freeze, [">= 3.8.5"])
  s.add_runtime_dependency(%q<jekyll-seo-tag>.freeze, [">= 2.0"])
  s.add_runtime_dependency(%q<jekyll-include-cache>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<rake>.freeze, [">= 12.3.1"])
end
