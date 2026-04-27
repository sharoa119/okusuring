Rails.application.routes.draw do
  get 'medication_records/create'
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  get "/auth/:provider/callback", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  resources :medication_schedules
  resources :medication_times, only: [] do
    resources :medication_records, only: :create
  end
end
