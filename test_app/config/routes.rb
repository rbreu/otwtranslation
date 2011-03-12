TestApp::Application.routes.draw do

  match "hello/world" => "hello#world"

  resources :user_sessions
  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'
  
   match 'devmode' => 'devmode#index'

  
  root :to => "home#index"  

  match ':controller(/:action(/:id(.:format)))'

end
