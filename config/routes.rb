Rails.application.routes.draw do
  mount_at = OtwtranslationConfig.MOUNT_AT
  match mount_at => 'otwtranslation/home#index'

  scope mount_at do
    resources :phrases, :controller => 'otwtranslation/phrases'
  end

end

