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

        ldap = get_ldap_connection

        result_attrs = ["sAMAccountName"]
        search_filter = Net::LDAP::Filter.eq("sAMAccountName", search_param)
        category_filter = Net::LDAP::Filter.eq("objectcategory", "user")
        member_filter = Net::LDAP::Filter.eq("memberof", "CN=ILL Billing,OU=Groups,OU=University Library,DC=AD,DC=UCSD,DC=EDU")
        s_c_filter = Net::LDAP::Filter.join(search_filter, category_filter)
        composite_filter = Net::LDAP::Filter.join(s_c_filter, member_filter)

        ldap.search(:filter => composite_filter, :attributes => result_attrs, :return_result => false) { |item| 
           result = item.sAMAccountName.first}

        get_ldap_response(ldap)

        return result
      end

      def self.get_ldap_connection
        ldap = Net::LDAP.new  :host => Rails.application.secrets.ldap_host, 
                              :port => Rails.application.secrets.ldap_port, 
                              :encryption => :simple_tls,
                              :base => Rails.application.secrets.ldap_base, 
                              :auth => {
                                :method => :simple,
                                :username => Rails.application.secrets.ldap_username, 
                                :password => Rails.application.secrets.ldap_password 
                          }
      end

      def self.get_ldap_response(ldap)
        msg = "Response Code: #{ ldap.get_operation_result.code }, Message: #{ ldap.get_operation_result.message }"
       
        raise msg unless ldap.get_operation_result.code == 0
      end
    end
  end
end