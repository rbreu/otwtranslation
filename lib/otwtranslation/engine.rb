module Otwtranslation
  require "otwtranslation"
  require "rails"

  class Engine < Rails::Engine
    p config.autoload_paths
    config.autoload_paths += ["#{config.root}/app/models/otwtranslation"]
    p config.autoload_paths
  end
end

