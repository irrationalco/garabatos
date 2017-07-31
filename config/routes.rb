Rails.application.routes.draw do
  root 'pages#dashboard'
  get 'top_products_chart', to: 'pages#top_products_chart'
  get 'bottom_products_chart', to: 'pages#bottom_products_chart'
  get 'best_products_chart', to: 'pages#best_products_chart'
  get 'worst_products_chart', to: 'pages#worst_products_chart'
  get 'units_ammount_chart', to: 'units#ammount_chart'
  get 'units_sales_chart', to: 'units#sales_chart'

  devise_for :users

  resources :ticket_products
  resources :tickets
  resources :units do
    member do
      get 'top_products_chart'
      get 'bottom_products_chart'
      get 'best_products_chart'
      get 'worst_products_chart'
    end
  end
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
