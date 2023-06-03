Rails.application.routes.draw do
  root "store#homepage"
  devise_for :users
end
