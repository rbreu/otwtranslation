Rails.application.routes.draw do
  mount_at = OtwtranslationConfig.MOUNT_AT
  match mount_at => 'otwtranslation/home#index'

end

