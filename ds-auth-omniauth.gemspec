# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ds-auth-omniauth/version"

Gem::Specification.new do |spec|
  spec.name          = "ds-auth-omniauth"
  spec.version       = DsAuth::Omniauth::VERSION
  spec.authors       = ["Chris Carter", "Pedro Moreira", "Anson Kelly"]
  spec.email         = ["chris.carter@unboxedconsulting.com", "pedro.moreira@unboxedconsulting.com", "ansonkelly@gmail.com"]

  spec.summary       = %q{ Omniauth strategy for MoJ Digital SSO provider }
  spec.description   = %q{ Omniauth strategy for MoJ Digital SSO provider }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2'

  spec.add_dependency "multi_json", "~> 1.11.0"
  spec.add_runtime_dependency "omniauth-oauth2", "~> 1.2.0"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.2'
end
