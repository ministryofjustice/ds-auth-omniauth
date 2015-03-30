# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omniauth-dsds/version"

Gem::Specification.new do |spec|
  spec.name          = "omniauth-dsds"
  spec.version       = Omniauth::Dsds::VERSION
  spec.authors       = ["Chris Carter", "Pedro Moreira"]
  spec.email         = ["chris.carter@unboxedconsulting.com", "pedro.moreira@unboxedconsulting.com"]

  spec.summary       = %q{ Omniauth strategy for Defence Request Service oAuth2 provider }
  spec.description   = %q{ Omniauth strategy for Defence Request Service oAuth2 provider }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json", "~> 1.11.0"
  spec.add_runtime_dependency "omniauth-oauth2", "~> 1.2.0"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "dotenv", "~> 2.0.0"
  spec.add_development_dependency 'rspec', '~> 2.7'
  spec.add_development_dependency 'rack-test'
end
