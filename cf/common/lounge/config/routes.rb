Rails.application.routes.draw do
  resources :items
  root to: 'items#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/hi', to: 'health_check#index'
end
