Rails.application.routes.draw do
  match '/translation' => 'translation#home'
end
