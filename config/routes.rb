require 'sidekiq/web'

Rails.application.routes.draw do  
  mount ActionCable.server => '/cable'
  
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  get 'new_user', to: 'users#new', as: 'new_user'
  post 'create_user'  , to: 'users#create', as: 'create_user'

  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create destroy update] do
        resources :answers, only: %i[index show create destroy update], shallow: true
      end
    end
  end

  concern :votable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  concern :commentable do
    post  :create_comment, on: :member
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], only: %i[create destroy update], shallow: true
    
    patch :set_best_answer, on: :member    
  end

  resources :links, only: :destroy

  delete 'attachments/:id/purge', to: 'attachments#purge', as: 'purge_attachment'  

  get 'users/:id/awards', to: 'users#awards', as: 'awards_user'  

  # for tests
  default_url_options :host => "127.0.0.1:3000"
end
