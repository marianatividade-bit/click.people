Rails.application.routes.draw do
  devise_for :people,
             controllers: { omniauth_callbacks: "people/omniauth_callbacks" },
             skip: [:registrations, :passwords, :confirmations, :unlocks, :sessions]

  devise_scope :person do
    get  "/login",  to: "people/sessions#new",     as: :new_person_session
    delete "/logout", to: "people/sessions#destroy", as: :destroy_person_session
  end

  resources :cycles, only: [:index, :new, :create, :show]
  resources :people, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
end
