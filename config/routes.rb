Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :recipes, only: [:index]
      resources :learning_resources, only: [:index]
      resources :users, only: [:create]
    end
  end
end
