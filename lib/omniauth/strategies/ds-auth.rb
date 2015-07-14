require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class DsAuth < OmniAuth::Strategies::OAuth2
      option :name, "ds_auth"

      option :client_options, {
        site: ENV.fetch('DS_AUTH_SITE_URL', nil),
        redirect_url: ENV.fetch('DS_AUTH_REDIRECT_URI', nil),
        raw_info_path: ENV.fetch("DS_AUTH_RAW_INFO_PATH") { "/api/v1/me" }
      }

      uid { raw_info["user"]["uid"] }

      info do
        {
          "name" => raw_info["user"]["name"],
          "email" => raw_info["user"]["email"],
          "phone" => raw_info["user"]["telephone"],
          "mobile" => raw_info["user"]["mobile"],
          "full_address" => raw_info["user"]["address"]["full_address"],
          "postcode" => raw_info["user"]["address"]["postcode"],
          "organisations" => raw_info["organisations"]
        }
      end

      def raw_info
        @_raw_info ||= MultiJson.decode fetch_raw_info
        log_request
        @_raw_info
      end

      private

      def fetch_raw_info
        access_token.get(raw_info_path).body
      end

      def raw_info_path
        options.client_options.raw_info_path
      end

      def full_raw_info_url
        options.client_options.site + raw_info_path
      end

      def log_request
        return unless ENV["DS_AUTH_DEBUG"]

        require 'pp'
        puts "\n#{full_raw_info_url} result:"
        pp @_raw_info
        puts "curl -H \"Accept: application/json\" -H \"Authorization: Bearer #{access_token.token}\" #{full_raw_info_url}\n\n"
      end
    end
  end
end
