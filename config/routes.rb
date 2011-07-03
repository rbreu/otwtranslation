Rails.application.routes.draw do
  mount_at = OtwtranslationConfig.MOUNT_AT
  
  get mount_at => 'otwtranslation/home#index', :as => 'otwtranslation_home'
  
  get "#{mount_at}/toggle_tools" => 'otwtranslation/home#toggle_tools',
  :as => 'otwtranslation_toggle_tools'


  # Assignments
  
  get "#{mount_at}/assignments" => 'otwtranslation/assignments#index',
  :as => 'otwtranslation_assignments'

  get "#{mount_at}/assignments/new" => 'otwtranslation/assignments#new',
  :as => 'otwtranslation_new_assignment'

  match "#{mount_at}/assignments/" => 'otwtranslation/assignments#create',
  :as => 'otwtranslation_post_assignment', :via => [:post]
  
  get "#{mount_at}/assignments/:id" => 'otwtranslation/assignments#show',
  :as => 'otwtranslation_assignment'



  # Sources
  
  get "#{mount_at}/sources" => 'otwtranslation/sources#index',
  :as => 'otwtranslation_sources'

  get "#{mount_at}/sources/:id" => 'otwtranslation/sources#show',
  :as => 'otwtranslation_source'

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

  
  # Rules
  
  get "#{mount_at}/languages/:id/rules/new" => 'otwtranslation/rules#new',
  :as => 'otwtranslation_new_rule'

  match "#{mount_at}/languages/:id/rules/" => 'otwtranslation/rules#create',
  :as => 'otwtranslation_post_rule', :via => [:post]

  get "#{mount_at}/rules/:id/confirm_destroy" => 'otwtranslation/rules#confirm_destroy',
  :as => 'otwtranslation_confirm_destroy_rule'

  get "#{mount_at}/rules/:id/move_down" => 'otwtranslation/rules#move_down',
  :as => 'otwtranslation_move_down_rule'

  get "#{mount_at}/rules/:id/move_up" => 'otwtranslation/rules#move_up',
  :as => 'otwtranslation_move_up_rule'

  get "#{mount_at}/rules/:id/edit" => 'otwtranslation/rules#edit',
  :as => 'otwtranslation_edit_rule'

  match "#{mount_at}/rules/:id" => 'otwtranslation/rules#destroy',
  :as => 'otwtranslation_destroy_rule', :via => [:delete]
  
  match "#{mount_at}/rules/:id" => 'otwtranslation/rules#update',
  :as => 'otwtranslation_update_rule', :via => [:put]

  

  
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
  
  get "#{mount_at}/translations/:id/confirm_destroy" => 'otwtranslation/translations#confirm_destroy',
  :as => 'otwtranslation_confirm_destroy_translation'
  
  match "#{mount_at}/translations/:id/vote" => 'otwtranslation/translations#vote',
  :as => 'otwtranslation_vote_translation', :via => [:put]
    
  get "#{mount_at}/translations/:id/edit" => 'otwtranslation/translations#edit',
  :as => 'otwtranslation_edit_translation'
  
  get "#{mount_at}/translations/:id" => 'otwtranslation/translations#show',
  :as => 'otwtranslation_translation'

  match "#{mount_at}/translations/:id" => 'otwtranslation/translations#destroy',
  :as => 'otwtranslation_destroy_translation', :via => [:delete]
  
  match "#{mount_at}/translations/:id" => 'otwtranslation/translations#update',
  :as => 'otwtranslation_update_translation', :via => [:put]
    
end

