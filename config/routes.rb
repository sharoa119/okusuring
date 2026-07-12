# frozen_string_literal: true

Rails.application.routes.draw do
  get 'about', to: 'pages#about'
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'home#index'

  get '/auth/:provider/callback', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy', as: :logout

  resources :medication_schedules
  resources :medication_times, only: [] do
    resources :medication_records, only: %i[create destroy]
  end
  resources :family_links, only: %i[index create destroy]

  get 'notification_settings', to: 'notification_settings#show'
  patch 'notification_settings', to: 'notification_settings#update'

  # LINE関連
  get '/invite/:token', to: 'family_links#accept', as: :invite
  post '/webhook', to: 'line_bot#callback'
end
