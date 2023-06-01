Rails.application.routes.draw do
  root "store#homepage", as: 'store_homepage', via: :all
  devise_for :users, controllers: { :sessions => "user/sessions" }

  namespace :admin do
    resources :deals do
      patch 'check_publishablity', to: 'deals#check_publishablity', on: :member
    end
  end
end
