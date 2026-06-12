Rails.application.routes.draw do
  devise_for :people,
             controllers: { omniauth_callbacks: "people/omniauth_callbacks" },
             skip: [:registrations, :passwords, :confirmations, :unlocks, :sessions]

  devise_scope :person do
    get    "/login",  to: "people/sessions#new",     as: :new_person_session
    delete "/logout", to: "people/sessions#destroy", as: :destroy_person_session
    get    "/logout", to: redirect("/login")
  end

  resources :cycles, only: [:index, :new, :create, :show, :update, :destroy] do
    resource :nine_box, only: [:show, :edit, :update], controller: "nine_box"
    resources :questions, only: [:create, :update, :destroy], shallow: true do
      member do
        patch :reorder
      end
    end
    resources :nominations, only: [:index, :create, :destroy] do
      collection do
        get :validate_index
      end
      member do
        patch :approve
        patch :reject
      end
    end
    resources :evaluation_plans, only: [:create, :destroy],
                                  controller: "cycle_evaluation_plans" do
      collection do
        post   :bulk_add
        delete :remove_evaluated
      end
    end
    member do
      get  :progress
      get  :configure
      patch :configure, action: :update_configure
      patch :advance
      patch :duplicate
    end
  end
  resources :people, only: [:index, :show, :edit, :update]
  resources :evaluations, only: [:index, :show, :edit, :update]
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
    resources :people, only: [:index, :new, :create, :edit, :update, :destroy] do
      member do
        patch :deactivate
        patch :reactivate
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
end
