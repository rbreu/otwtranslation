Rails.application.routes.draw do
  mount_at = OtwtranslationConfig.MOUNT_AT
  
  match mount_at => 'otwtranslation/home#index', :as => 'otwtranslation_home'
  match "#{mount_at}/toggle_tools" => 'otwtranslation/home#toggle_tools',
  :as => 'otwtranslation_toggle_tools'

  match "#{mount_at}/phrases/:id" => 'otwtranslation/phrases#show',
  :as => 'otwtranslation_phrase'
  
  match "#{mount_at}/phrases" => 'otwtranslation/phrases#index',
  :as => 'otwtranslation_phrases'

  match "#{mount_at}/sources/:id" => 'otwtranslation/sources#show',
  :as => 'otwtranslation_source'
  
  match "#{mount_at}/sources" => 'otwtranslation/sources#index',
  :as => 'otwtranslation_sources'

end

