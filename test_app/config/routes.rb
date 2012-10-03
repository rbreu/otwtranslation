TestApp::Application.routes.draw do

  filter :otw_translation_locale_filter

  match "hello/world" => "hello#world"

  resources :user_sessions

  resources :comments do
    member do
      put :approve
      put :reject
    end
    collection do
      get :hide_comments
      get :show_comments
      get :add_comment
      get :cancel_comment
      get :add_comment_reply
      get :cancel_comment_reply
      get :cancel_comment_edit
      get :delete_comment
      get :cancel_comment_delete
    end
    resources :comments
  end
  
  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'
  
  match 'devmode' => 'devmode#index'

  
  root :to => "home#index"

  match ':controller(/:action(/:id(.:format)))'

end
