Hydra::Shibboleth::Engine.config.middleware.use OmniAuth::Builder do
  provider :shibboleth, {
    :uid_field                 => 'ADUSERNAME',
      :shib_session_id_field     => "Shib-Session-ID",
      :shib_application_id_field => "Shib-Application-ID",
      :debug                     => false,
      :info_fields               => {:email => 'EMAIL', :name => 'FULL_NAME', :givenName => 'FIRST_NAME', :familyName => 'LAST_NAME'}
    }
end