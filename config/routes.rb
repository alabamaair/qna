# frozen_string_literal: true
Rails.application.routes.draw do
  concern :votable do
    member do
      put :vote_up
      put :vote_down
      delete :unvote
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions, concerns: :votable do
    put :mark_best_answer, on: :member
    resources :comments, only: :create, defaults: { commentable: 'question' }
    resources :answers, shallow: true, concerns: :votable do
      resources :comments, only: :create, defaults: { commentable: 'answer' }
    end
  end
  resources :attachments, only: :destroy
  resources :comments, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
