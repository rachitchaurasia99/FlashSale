Rails.application.routes.draw do
  root "store#homepage"
  devise_for :users, controllers: { :sessions => "user/sessions" }

  resources :users do
    resources :orders
  end
  
  resources :line_items
  resources :addresses

  resources :orders do
    member do
      post 'payment'
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
  
  namespace :admin do
    resources :deals do
      patch 'check_publishablity', to: 'deals#check_publishablity', on: :member
    end
  end
end
