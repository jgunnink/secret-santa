Rails.application.routes.draw do
  require 'sidekiq/web'
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Override registrations controller so we can manually set the role to 'Member'
  devise_for :users, controllers: {
    registrations: "devise_customisations/registrations",
    sessions: "devise_customisations/sessions"
  }

  resources :home, only: [:index, :health_check]
  root to: "home#index"

  # Healthcheck endpoint for validating rails is healthy.
  get '/health_check', to: 'home#health_check'

  namespace :admin do
    resources :dashboard, only: :index
    resources :members
    resources :admins
  end

  namespace :member do
    resources :dashboard, only: :index
    resources :lists do
      patch :lock_and_assign
      post :copy_list
      get :santas
      post :list_payment
      patch :reveal_santas
    end
  end
end
