# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hydra/shibboleth/version'

Gem::Specification.new do |spec|
  spec.name          = 'hydra-shibboleth'
  spec.version       = Hydra::Shibboleth::VERSION
  spec.authors       = ['Huawei Weng', 'Esmé Cowles']
  spec.email         = ['wengny@gmail.com', 'escowles@ticklefish.org']
  spec.summary       = 'Access control with Shibboleth & LDAP'
  spec.description   = 'A Rails engine to easily add support for access control with Shibboleth authentication and LDAP groups'
  spec.homepage      = 'https://github.com/projecthydra-labs/hydra-shibboleth'
  spec.license       = 'APACHE2'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 4.2.4'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "engine_cart", "~> 0.7"
  spec.add_development_dependency "rubocop", "~> 0.7"
end
