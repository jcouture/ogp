# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ogp/version'

Gem::Specification.new do |spec|
  spec.name          = 'ogp'
  spec.version       = OGP::VERSION
  spec.authors       = ['Jean-Philippe Couture']
  spec.email         = ['jcouture@gmail.com']

  spec.summary       = 'Simple Ruby library for parsing Open Graph prototocol information.'
  spec.description   = 'Simple Ruby library for parsing Open Graph prototocol information. See http://ogp.me for more information.'
  spec.homepage      = 'https://github.com/jcouture/ogp'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '>= 1.8.5'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 0.49.1'
end
