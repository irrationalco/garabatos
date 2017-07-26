Rails.application.routes.draw do
  root 'pages#home'
  get 'dashboard', to: 'pages#dashboard'
  get 'top_products_chart', to: 'pages#top_products_chart'
  get 'bottom_products_chart', to: 'pages#bottom_products_chart'
  get 'units_chart', to: 'pages#units_chart'

  devise_for :users

  resources :ticket_products
  resources :tickets
  resources :units do
    member do
      get 'top_products_chart'
      get 'bottom_products_chart'
    end
  end
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
