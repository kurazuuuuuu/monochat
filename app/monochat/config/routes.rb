Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Authentication routes (API)
  post "auth/register", to: "auth#register"
  post "auth/login", to: "auth#login"
  get "auth/me", to: "auth#me"

  # Session routes (HTML) - Unified auth
  get "login", to: "sessions#new"
  post "auth", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Spaces routes
  resources :spaces, only: [:index, :create], param: :space_uuid

  # Space detail route (custom to avoid nesting issues)
  get "spaces/:space_uuid", to: "spaces#show", as: :space

  # Messages routes (use space_uuid in path)
  get "spaces/:space_uuid/messages", to: "messages#index", as: :space_messages
  post "spaces/:space_uuid/messages", to: "messages#create"

  # Defines the root path route ("/")
  root "spaces#index"
end
