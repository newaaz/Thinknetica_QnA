Rails.application.routes.draw do  
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, only: %i[create destroy update], shallow: true
    patch :set_best_answer, on: :member
  end

  delete 'attachments/:id/purge', to: 'attachments#purge', as: 'purge_attachment'

  resources :links, only: %i[create destroy]
end
