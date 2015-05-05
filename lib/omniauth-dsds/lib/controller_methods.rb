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
        build_user || (reset_session; nil)
      end

      def build_user
        UserBuilder.new(
          app_id:     authentication_application_id,
          app_secret: authentication_application_secret,
          token:      access_token
        ).build_user
      end

      def authentication_application_id
        ENV.fetch('AUTHENTICATION_APPLICATION_ID')
      end

      def authentication_application_secret
        ENV.fetch('AUTHENTICATION_APPLICATION_SECRET')
      end
    end
  end
end
