module Otwtranslation
  require "otwtranslation"
  require "rails"

  class Engine < Rails::Engine
    config.mount_at = '/translation/'
  end
end

