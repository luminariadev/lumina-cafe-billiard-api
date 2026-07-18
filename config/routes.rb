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
      post "guest_transactions/billiard" => "guest_transactions#billiard_booking"
      post "guest_transactions/cafe" => "guest_transactions#cafe_order"
      get "guest_transactions/:id/status" => "guest_transactions#payment_status"
      post "guest_transactions/:id/pay" => "guest_transactions#simulate_payment"
    end
  end
end
