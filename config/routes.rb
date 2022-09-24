Rails.application.routes.draw do  
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  get 'new_user', to: 'users#new', as: 'new_user'
  post 'create_user'  , to: 'users#create', as: 'create_user'

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

  mount ActionCable.server => '/cable'

  # for tests
  default_url_options :host => "example.com"
end
