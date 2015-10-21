module API
  module Version1
    module Helpers
      def warden
        @warden ||= request.env["warden"]
      end

      def current_user
        @current_user ||= warden.user(:account)
      end

      def user_logged_in?
        warden.authenticated?(:account)
      end

      def authenticate_by_token!
        env['devise.skip_trackable'] = true
        warden.authenticate!(:token_authenticatable, :scope => :account)
      end

      def client_ip
        env["action_dispatch.remote_ip"].to_s
      end
    end
  end
end