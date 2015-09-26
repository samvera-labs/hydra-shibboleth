Hydra::Shibboleth::Engine.routes.draw do
 get "/signin", to: 'sessions#new', as: :signin
 get "/auth/shibboleth", as: :shibboleth
 get "/auth/developer", to: 'sessions#developer', as: :developer
 match "/auth/shibboleth/callback" => "sessions#shibboleth", as: :callback, via: [:get, :post]
 match "/signout" => "sessions#destroy", as: :signout, via: [:get, :post]
end
