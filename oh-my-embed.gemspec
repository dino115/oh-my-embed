# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oh_my_embed/version'

Gem::Specification.new do |spec|
  spec.name = 'oh-my-embed'
  spec.version = OhMyEmbed::VERSION
  spec.authors = ['Axel Wahlen']
  spec.email = ['axelwahlen@gmail.com']

  spec.summary = 'Simple gem to interact with oauth providers'
  spec.description = 'Simple gem to interact with oauth providers, for more informations see spec at http://www.oembed.com'
  spec.homepage = 'https://www.mixxt.de'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
