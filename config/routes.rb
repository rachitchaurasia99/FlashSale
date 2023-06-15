Rails.application.routes.draw do
  root "store#homepage"
  devise_for :users, controllers: { :sessions => "user/sessions", :registrations => "user/registrations" }

  devise_scope :user do
    get 'profile', to: 'user/registrations#profile'
  end

  resources :users do
    resources :orders
    member do
      delete :soft_delete
    end
  end
  
  resources :line_items

  resources :orders do
    member do
      post 'payment'
      post 'cancel_order', as: 'cancel'
      get 'success'
      get 'cancel'
      get 'checkout'
      get 'cart' 
      patch 'checkout'
    end
  end

  get 'past_deals', to: 'store#past_deals', as: :past_deals
  
  resources :address
  resources :payments, only: [:new, :create]
  
  namespace :api do
    controller :deals do
      get 'deals/live' => :live
      get 'deals/past' => :past
    end

    controller :users do
      get 'my_orders' => :my_orders
      post 'cancel_order/:id' => :cancel_order
    end
  end

  namespace :admin do
    controller :reports do
      get 'reports' => :index
      get 'reports/deals' => :deals
      get 'reports/customers' => :customers
    end
    resources :users do
      member do
        delete :soft_delete
      end
    end
    resources :orders do
      member do
        post 'deliver', to: 'orders#deliver_order'
        post 'cancel', to: 'orders#cancel_order'
      end
    end
    resources :deals do
      patch 'check_publishablity', to: 'deals#check_publishablity', on: :member
    end
  end
end
