require "omniauth-oauth2"

module OmniAuth
  module Strategies

    module CallbackOverride
      def callback_phase
        if raw_info['roles'].nil? || raw_info['roles'].empty?
          fail!(:unauthorized, OAuth2::CallbackError.new(:unauthorized, 'Unauthorized access'))
        else
          super
        end
      end
    end

    # Need to check roles after the access_token has been built by OmniAuth::OAuth2#callback_phase 
    # but before the parent app is called by OmniAuth::Strategy#callback_phase
    # so we place a module in the ancestors chain between them
    OAuth2.send :include, CallbackOverride

    class DefenceRequest < OmniAuth::Strategies::OAuth2
      option :name, "defence_request"

      option :client_options, {
        site: ENV.fetch('AUTHENTICATION_SITE_URL', nil),
        redirect_url: ENV.fetch('AUTHENTICATION_REDIRECT_URI', nil)
      }

      uid { raw_info["profile"]["uid"] }

      def raw_info
        @_raw_info ||= MultiJson.decode access_token.get("/api/v1/profiles/me").body
      end
    end
  end
end
