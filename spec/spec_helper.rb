$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hydra/shibboleth'
require 'engine_cart'
EngineCart.load_application!
