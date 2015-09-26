module Hydra
  module Shibboleth
    class SessionsController < ApplicationController
      def new
        if Rails.configuration.shibboleth
          redirect_to shibboleth_path
        else
          redirect_to developer_path
        end
      end

      def developer
        find_or_create_user('developer')
      end
      
      def shibboleth
        find_or_create_user('shibboleth')
      end

      def find_or_create_user(auth_type)
        find_or_create_method = "find_or_create_for_#{auth_type.downcase}".to_sym
        auth = request.env["omniauth.auth"]
        user = User.send(find_or_create_method,auth)
        
        if auth_type == 'shibboleth' && !User.in_supergroup?(auth.uid) 
          render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
        else
          create_user_session(user) if user
          redirect_to root_url, notice: "You have successfully authenticated from #{auth_type} account!" 
        end
      end

      def destroy
        destroy_user_session
        flash[:alert] = ('You have been logged out of this application. To logout of all Single Sign-On applications, close your browser or <a href="/Shibboleth.sso/Logout?return=https://a4.ucsd.edu/tritON/logout?target='+root_url+'">terminate your Shibboleth session</a>.').html_safe if Rails.configuration.shibboleth
        
        redirect_to root_url
      end 

      private

      def create_user_session(user)
        session[:user_name] = user.full_name
        session[:user_id] = user.uid
      end

      def destroy_user_session
        session[:user_id] = nil
        session[:user_name] = nil
      end
    end
  end
end