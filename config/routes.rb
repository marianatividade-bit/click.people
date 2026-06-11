Rails.application.routes.draw do
  devise_for :people,
             controllers: { omniauth_callbacks: "people/omniauth_callbacks" },
             skip: [:registrations, :passwords, :confirmations, :unlocks]

  get "up" => "rails/health#show", as: :rails_health_check

  # root provisório — substituir quando a home por role estiver pronta
  root "dashboard#index"
end
