require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Dsds < OmniAuth::Strategies::OAuth2
      option :name, "dsds"
    end
  end
end
