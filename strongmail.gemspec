# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strongmail/version'

Gem::Specification.new do |spec|
  spec.name          = "strongmail"
  spec.version       = Strongmail::VERSION
  spec.authors       = ["Wyatt Research"]
  spec.email         = ["charles.sprayberry@wyattresearch.com"]
  spec.summary       = "Strongmail API Client"
  spec.description   = "A Ruby client to facilitate making HTTP calls to the Wyatt Research StrongMail API"
  spec.homepage      = ""
  spec.license       = "Proprietary"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
