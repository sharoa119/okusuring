Rails.application.routes.draw do
  get 'medication_records/create'
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  get "/auth/:provider/callback", to: "sessions#create"

  delete "/logout", to: "sessions#destroy", as: :logout

  resources :medication_schedules
  resources :medication_times, only: [] do
    resources :medication_records, only: :create
  end
  resources :family_links, only: [:index, :create]

  # LINE関連
  get "/invite/:token", to: "family_links#accept", as: :invite
  post "/webhook", to: "line_bot#callback"
end
