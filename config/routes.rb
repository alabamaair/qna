# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    put :mark_best_answer, on: :member
    resources :answers, shallow: true
  end
  resources :attachments, only: :destroy

  root to: 'questions#index'
end
