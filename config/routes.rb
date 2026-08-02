Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :branches
      resources :mejas
      resources :products
      resources :transaksis
      post 'auth/login', to: 'authentication#login'
    end
  end
end
