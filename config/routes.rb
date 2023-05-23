Rails.application.routes.draw do
  root "store#homepage", as: 'store_homepage', via: :all
  devise_for :users
end
