Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :branches
      resources :mejas
      resources :products
      resources :transaksis
      resources :items
      resources :inventory_transactions
      resources :suppliers
      resources :purchase_orders
      resources :loyalty_tiers
      resources :shifts
      resources :receipts, only: [:show]
      resources :guest_orders, only: [:create]
      get 'loyalty/points', to: 'loyalty#points'
      get 'loyalty/tiers', to: 'loyalty#tiers'
      post 'loyalty/earn', to: 'loyalty#earn'
      post 'loyalty/redeem', to: 'loyalty#redeem'
      post 'shifts/clock_in', to: 'shifts#clock_in'
      post 'shifts/clock_out', to: 'shifts#clock_out'
      get 'invoices/:id', to: 'invoices#show'
      get 'reports/analytics', to: 'reports#analytics'
      get 'orders/pending', to: 'orders_channel#index'
      get 'orders/latest', to: 'orders_channel#latest'
      patch 'orders/:id/status', to: 'orders_channel#update_status'
      get 'guest_orders/menu', to: 'guest_orders#menu'
      get 'guest_orders/status', to: 'guest_orders#status'
      post 'auth/login', to: 'authentication#login'
    end
  end
end
