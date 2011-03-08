Rails.application.routes.draw do
  mount_at = OtwtranslationConfig.MOUNT_AT
  match mount_at => 'otwtranslation/home#index'

  match "#{mount_at}/phrases/:key" => 'otwtranslation/phrases#show',
  :as => "otwtranslation_phrase"
  
  match "#{mount_at}/phrases" => 'otwtranslation/phrases#index',
  :as => "otwtranslation_phrases"

end

