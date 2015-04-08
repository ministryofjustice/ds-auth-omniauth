module Omniauth
  module Dsds
    module ControllerMethods
      def self.included(controller)
        controller.helper_method :current_user
      end

      def current_user
        @current_user ||= fetch_current_user
      end

      protected

      def authenticate_user!
        redirect_to "/auth/defence_request" unless current_user
      end

      def access_token
        session[:user_token]
      end

      def fetch_current_user
        return nil unless access_token
        build_user

      rescue OAuth2::Error
        reset_session
        nil
      end

      def build_user
        User.build_from strategy_with_access_token(token: access_token).raw_info
      end

      def strategy
        OmniAuth::Strategies::DefenceRequest.new ENV.fetch('AUTHENTICATION_APPLICATION_ID'), ENV.fetch('AUTHENTICATION_APPLICATION_SECRET')
      end

      def strategy_with_access_token(token: )
        strategy.tap do |strat|
          strat.access_token = OAuth2::AccessToken.new strat.client, token
        end
      end
    end
  end
end
