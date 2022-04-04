lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-code-tabs/version"
Gem::Specification.new do |spec|
  spec.name          = "jekyll-code-tabs"
  spec.summary       = "Fenced code tabs for Jekyll"
  spec.description   = "Separate language snippets with fenced code tabs for documentation pages"
  spec.version       = Jekyll::CodeTabs::VERSION
  spec.authors       = ["Brett Fowle"]
  spec.email         = ["brettfowle@gmail.com"]
  spec.homepage      = "https://github.com/clustergarage/jekyll-code-tabs"
  spec.licenses      = ["MIT"]
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|spec|features)/!)  }
  spec.require_paths = ["lib"]
  spec.add_dependency "jekyll", ">= 3.0", "< 5.0"
  spec.add_development_dependency "rake", "~> 13.0.1"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rubocop", "~> 0.52"
end