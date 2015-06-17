require "omniauth-oauth2"

module OmniAuth
  module Strategies
    module CallbackOverride
      def callback_phase
        unless has_roles?(raw_info)
          fail!(:unauthorized, OAuth2::CallbackError.new(:unauthorized, 'Unauthorized access'))
        else
          super
        end
      end

      def has_roles?(raw_info)
        raw_info["user"]["organisations"].any? do |organisation|
          !organisation["roles"].nil? && !organisation["roles"].empty?
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
        redirect_url: ENV.fetch('AUTHENTICATION_REDIRECT_URI', nil),
        raw_info_path: ENV.fetch("AUTHENTICATION_RAW_INFO_PATH") { "/api/v1/me" }
      }

      uid { raw_info["user"]["uid"] }

      def raw_info
        log_request
        @_raw_info ||= MultiJson.decode access_token.get(raw_info_path).body
      end

      private

      def raw_info_path
        options.client_options.raw_info_path
      end

      def full_raw_info_url
        options.client_options.site + raw_info_path
      end

      def log_request
        return unless ENV["OAUTH_DEBUG"]

        log :debug, "curl -H \"Accept: application/json\" -H \"Authorization: Bearer #{access_token.token}\" #{full_raw_info_url}"
      end
    end
  end
end
