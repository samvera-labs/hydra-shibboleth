module Hydra
  module Shibboleth
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception
      helper_method :current_user, :logged_in?
      
      def current_user
        @current_user ||= User.find_by uid: session[:user_id] if session[:user_id]
      end

      def logged_in?
        !!current_user 
      end

      def require_user
        redirect_to signin_path, notice: 'You need to sign in!' unless logged_in?
      end
    end
  end
end
