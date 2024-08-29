Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root 'welcome#index'
  get '/register', to: 'users#new', as: 'register_user'

  resources :users, only: %i[show create] do
    member do
      get 'discover'
    end

    resources :movies, only: %i[index show], module: :users do
      resources :viewing_parties, only: %i[show create new], module: :movies
      member do
        get 'similar'
      end
    end
  end
end
