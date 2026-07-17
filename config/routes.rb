Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      get "auth/me", to: "auth#me"
      resources :categories
      resources :products
      resources :mejas
      resources :transaksis do
        member { post :pay }
        collection { get :report; post :cafe_pos }
      end
      resources :reports, only: [:index]
    end
  end
end
