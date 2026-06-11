Rails.application.routes.draw do
  devise_for :people,
             controllers: { omniauth_callbacks: "people/omniauth_callbacks" },
             skip: [:registrations, :passwords, :confirmations, :unlocks, :sessions]

  devise_scope :person do
    get    "/login",  to: "people/sessions#new",     as: :new_person_session
    delete "/logout", to: "people/sessions#destroy", as: :destroy_person_session
    get    "/logout", to: redirect("/login")
  end

  resources :cycles, only: [:index, :new, :create, :show] do
    resource :nine_box, only: [:show, :edit, :update], controller: "nine_box"
    member do
      get :progress
    end
  end
  resources :people, only: [:index, :show, :edit, :update]
  resources :evaluations, only: [:index, :new, :create, :show, :update]
  resources :pdis, only: [:index, :new, :create, :show, :edit, :update]
  resources :recovery_plans, only: [:index, :new, :create, :show, :edit, :update]
  resources :feedbacks, only: [:index, :new, :create, :show]
  resources :notifications, only: [:index] do
    collection do
      patch :mark_all_read
    end
    member do
      patch :mark_read
    end
  end
  get "/nine_box", to: "nine_box#index", as: :nine_box

  namespace :admin do
    root "dashboard#index"
    resources :cargos
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
end
