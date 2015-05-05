module Omniauth
  module Dsds
    class UserBuilder

      class NullRawInfo
        def initialize
          @data = {
            "profile" => {
              "uid" => "",
              "name" => "",
              "email" => "",
              "organisation_uids" => []
            },
            "roles" => []
          }
        end

        def [](key)
          @data[key]
        end
      end

      def initialize(app_id:, app_secret:)
        app_id = app_id
        app_secret = app_secret
      end

      def build_user(token)
        return nil unless token

        raw_info = fetch_raw_info(token)

        unless raw_info['roles'].nil? || raw_info['roles'].empty?
          User.build_from raw_info
        end
      end

      private

      attr_reader :access_token, :app_id, :app_secret

      def strategy
        OmniAuth::Strategies::DefenceRequest.new app_id, app_secret
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
