module DsAuth
  module Omniauth
    class UserBuilder
      class NullRawInfo
        def initialize
          @data = {
            "user" => {
              "uid" => "",
              "name" => "",
              "email" => "",
              "organisations" => []
            }
          }
        end

        def [](key)
          @data[key]
        end
      end

      def initialize(app_id:, app_secret:, token:)
        @app_id = app_id
        @app_secret = app_secret
        @token = token
      end

      def build_user
        return nil unless token

        raw_info = fetch_raw_info(token)

        User.build_from(raw_info)
      end

      private

      attr_reader :token, :app_id, :app_secret

      def strategy
        OmniAuth::Strategies::DsAuth.new app_id, app_secret
      end

      def strategy_with_access_token(token: )
        strategy.tap do |strat|
          strat.access_token = OAuth2::AccessToken.new strat.client, token
        end
      end

      def fetch_raw_info(token)
        strategy_with_access_token(token: token).raw_info

        rescue OAuth2::Error
          NullRawInfo.new
      end
    end
  end
end
