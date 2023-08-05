Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'
  
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :posts do
    collection do
      get 'filter'
      # get 'search'
    end
  end
  resources :posts, only: [:index]
  get 'posts/search', to: 'posts#search', as: 'search_posts'
  get '/my_posts', to: 'users#my_posts', as: :my_posts
  get '/profile', to: 'users#profile', as: :user_profile
  get '/users/:id', to: 'users#show', as: :user_profile_view

  resources :users, only: [:show]

  resources :posts, only: [:create]

  resources :posts, only: [:update, :destroy]

  resources :users, only: [] do
    get 'profile', on: :collection
    get 'my_posts', on: :collection
  end

  resources :follows, only: [:create]

  resources :users, only: [:show]

  resources :likes, only: [:create]

  resources :comments, only: [:create]


  resources :posts, only: [:index, :create, :update, :destroy] do
    collection do
      get 'top_posts', to: 'posts#top_posts'
      get 'recommended_posts', to: 'posts#recommended_posts'
    end
    member do
      get 'more_posts_by_author', to: 'posts#more_posts_by_author'
    end
  end
  # get '/posts/search', to: 'posts#search', as: :search_posts
  # get '/my_posts', to: 'users#my_posts', as: :my_posts

  # get '/profile', to: 'users#profile', as: :user_profile
  # get '/users/:id', to: 'users#show', as: :user_profile_view


end