require 'dotenv'
Dotenv.load

$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'rspec'
require 'rack/test'
require 'omniauth'
require 'omniauth-dsds'


RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
