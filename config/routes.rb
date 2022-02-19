Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :update, :destroy]

      post 'authenticate', to: 'authentication#create'
    end
  end
end