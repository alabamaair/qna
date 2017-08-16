# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  concern :votable do
    member do
      put :vote_up
      put :vote_down
      delete :unvote
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post 'enter_email', to: 'omniauth_callbacks#enter_email'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions, concerns: :votable do
    put :mark_best_answer, on: :member
    resources :comments, only: :create, defaults: { commentable: 'question' }
    resources :subscriptions, only: [:create, :destroy], shallow: true
    resources :answers, shallow: true, concerns: :votable do
      resources :comments, only: :create, defaults: { commentable: 'answer' }
    end
  end
  resources :attachments, only: :destroy
  resources :comments, only: :destroy

  resource :search, only: :show, controller: 'search'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
