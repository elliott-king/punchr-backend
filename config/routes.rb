Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :shifts, only: [:index] do
    get 'current', on: :collection
  end

  resources :users, only: [:index] do
    member do
      get 'shifts'
      post 'shifts', to: 'users#punch'
      get 'current'
      get 'wages_last_30'
      get 'wages_pay_period'
    end
  end
end
