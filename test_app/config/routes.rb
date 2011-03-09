TestApp::Application.routes.draw do

  match "hello/world" => "hello#world"
  root :to => "home#index"

end
