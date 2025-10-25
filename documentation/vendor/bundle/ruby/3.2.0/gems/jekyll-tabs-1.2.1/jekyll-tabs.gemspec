lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-tabs/version'

Gem::Specification.new do |spec|

  spec.name          = 'jekyll-tabs'
  spec.summary       = 'A Jekyll plugin to add tabs'
  spec.description   = 'Generate a tabbed interface on top of markup'
  spec.version       = Jekyll::Tabs::VERSION

  spec.authors       = ['Nejc Zdovc', 'Baptiste Bouchereau']
  spec.email         = ['baptiste.bouchereau@gmail.com']
  spec.homepage      = 'https://github.com/ovski4/jekyll-tabs'
  spec.licenses      = ['MIT']

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|spec|features)/!)  }
  spec.require_paths = ['lib']
  spec.add_dependency 'jekyll', '>= 3.0', '< 5.0'
end
