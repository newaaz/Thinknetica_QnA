Rails.application.routes.draw do  
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  resources :questions do
    resources :answers, only: %i[create destroy update], shallow: true do
      concerns  :votable
    end
    
    patch :set_best_answer, on: :member
    concerns  :votable
  end

  delete 'attachments/:id/purge', to: 'attachments#purge', as: 'purge_attachment'

  resources :links, only: :destroy

  get 'users/:id/awards', to: 'users#awards', as: 'awards_user'
end
