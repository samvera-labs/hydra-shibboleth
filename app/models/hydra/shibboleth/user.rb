require 'net/ldap'

module Hydra
  module Shibboleth
    class User < ActiveRecord::Base
      def self.find_or_create_for_shibboleth(access_token)
        begin
          uid = access_token.uid
          email = access_token['info']['email'] || "#{uid}@ucsd.edu"
          provider = access_token.provider
          name = access_token['info']['name'] 
          
        rescue Exception => e
          logger.warn "shibboleth: #{e.to_s}"
        end
        
        u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email, :full_name => name)
      end

      # dummy auth for developer environment
      def self.find_or_create_for_developer(access_token)
         uid = 1
         email = "developer@ucsd.edu"
         provider = "developer"
         name = "DEVELOPER"
        
        u = User.where(:uid => uid,:provider => provider).first || User.create(:uid => uid,:provider => provider, :email => email, :full_name => name)
      end

      def self.in_supergroup?(uid)
        lookup_group(uid) == uid ? true : false
      end
      
      def self.lookup_group(search_param)
        result = ""
        ldap = get_ldap_connection  #calling Hydra::LDAP.connection is not working, using local implementation instead.
        result_attrs = ["sAMAccountName"]
        composite_filter = Net::LDAP::Filter.construct("(&(sAMAccountName=#{search_param})(objectcategory=user)(memberof=#{ldap_group_base}))")
        
        ldap.search(:filter => composite_filter, :attributes => result_attrs, :return_result => false) { |item| 
           result = item.sAMAccountName.first}
        
        get_ldap_response(ldap)
        result
      end

      def self.get_ldap_connection 
          @ldap_conn ||= Net::LDAP.new(ldap_connection_config)
      end

      def self.ldap_connection_config
        return @ldap_connection_config if @ldap_connection_config
        @ldap_connection_config = {}
        yml = ldap_config
        @ldap_connection_config[:host] = yml[:host]
        @ldap_connection_config[:port] = yml["port"]
        @ldap_connection_config[:encryption] = :simple_tls
        if yml["username"] && yml["password"]
          @ldap_connection_config[:auth]={:method=>:simple}
          @ldap_connection_config[:auth][:username] = yml["username"]
          @ldap_connection_config[:auth][:password] = yml["password"]
          @ldap_connection_config[:base] = yml["base"]
        end
        @ldap_connection_config
      end

      def self.ldap_config
        root = Rails.root || '.'
        env = Rails.env || 'test'
        @ldap_config ||= YAML::load(ERB.new(IO.read(File.join(root, 'config', 'hydra-ldap.yml'))).result)[env].with_indifferent_access
      end

      def self.ldap_group_base
        yml = ldap_config
        return yml["group_base"]
      end

      def self.get_ldap_response(ldap)
        msg = "Response Code: #{ ldap.get_operation_result.code }, Message: #{ ldap.get_operation_result.message }"
       
        raise msg unless ldap.get_operation_result.code == 0
      end
    end
  end
end