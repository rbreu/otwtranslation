Rails.application.routes.draw do
  mount_at = OtwtranslationConfig.MOUNT_AT
  
  get mount_at => 'otwtranslation/home#index', :as => 'otwtranslation_home'
  
  get "#{mount_at}/toggle_tools" => 'otwtranslation/home#toggle_tools',
  :as => 'otwtranslation_toggle_tools'


  # Phrases
  
  get "#{mount_at}/phrases" => 'otwtranslation/phrases#index',
  :as => 'otwtranslation_phrases'

  get "#{mount_at}/phrases/:id" => 'otwtranslation/phrases#show',
  :as => 'otwtranslation_phrase'

  # Sources
  
  get "#{mount_at}/sources" => 'otwtranslation/sources#index',
  :as => 'otwtranslation_sources'

  get "#{mount_at}/sources/:id" => 'otwtranslation/sources#show',
  :as => 'otwtranslation_source'

  # Languages
  
  get "#{mount_at}/languages" => 'otwtranslation/languages#index',
  :as => 'otwtranslation_languages'

  get "#{mount_at}/languages/new" => 'otwtranslation/languages#new',
  :as => 'otwtranslation_new_language'

  get "#{mount_at}/languages/select" => 'otwtranslation/languages#select',
  :as => 'otwtranslation_select_language'

  match "#{mount_at}/languages/" => 'otwtranslation/languages#create',
  :as => 'otwtranslation_post_language', :via => [:post]
  
  get "#{mount_at}/languages/:id" => 'otwtranslation/languages#show',
  :as => 'otwtranslation_language'

  
  # Translations
  
  get "#{mount_at}/phrases/:id/translations/new" => 'otwtranslation/translations#new',
  :as => 'otwtranslation_new_translation'

  match "#{mount_at}/phrases/:id/translations/" => 'otwtranslation/translations#create',
  :as => 'otwtranslation_post_translation', :via => [:post]
  
  match "#{mount_at}/translations/:id/approve" => 'otwtranslation/translations#approve',
  :as => 'otwtranslation_approve_translation', :via => [:post]
  
  get "#{mount_at}/translations/:id/confirm_disapprove" => 'otwtranslation/translations#confirm_disapprove',
  :as => 'otwtranslation_confirm_disapprove_translation'
  
  match "#{mount_at}/translations/:id/disapprove" => 'otwtranslation/translations#disapprove',
  :as => 'otwtranslation_disapprove_translation', :via => [:post]
  
end

