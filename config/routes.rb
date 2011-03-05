Rails.application.routes.draw do
  mount_at = Otwtranslation::Engine.config.mount_at

  match mount_at => 'otwtranslation/home#index'

end

