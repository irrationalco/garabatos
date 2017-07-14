Rails.application.routes.draw do
  root 'pages#home'
  get 'dashboard', to: 'pages#dashboard'

  devise_for :users

  resources :ticket_products
  resources :tickets
  resources :units
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
