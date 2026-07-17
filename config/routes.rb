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
        collection { get :report }
      end
    end
  end
end
