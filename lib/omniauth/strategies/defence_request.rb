require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class DefenceRequest < OmniAuth::Strategies::OAuth2
      option :name, "defence_request"

      option :client_options, {
        site: ENV.fetch('AUTHENTICATION_SITE_URL'),
        redirect_url: ENV.fetch('AUTHENTICATION_REDIRECT_URI')
      }

      uid { raw_info["profile"]["uid"] }

      def raw_info
        @_raw_info ||= MultiJson.decode access_token.get("/api/v1/profiles/me").body
      end
    end
  end
end
