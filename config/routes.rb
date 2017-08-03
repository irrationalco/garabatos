Rails.application.routes.draw do
  root 'pages#home'
  get 'dashboard', to: 'pages#dashboard'

  get 'top_products_chart', to: 'pages#top_products_chart'
  get 'bottom_products_chart', to: 'pages#bottom_products_chart'
  get 'best_products_chart', to: 'pages#best_products_chart'
  get 'worst_products_chart', to: 'pages#worst_products_chart'
  get 'top_products_sales_chart', to: 'pages#top_products_sales_chart'
  get 'bottom_products_sales_chart', to: 'pages#bottom_products_sales_chart'

  get 'units_ammount_chart', to: 'units#ammount_chart'

  get 'pareto_chart', to: 'pages#pareto_chart'

  resources :units, only: [:index, :show] do
    member do
      get 'top_products_chart'
      get 'bottom_products_chart'
      get 'best_products_chart'
      get 'worst_products_chart'
      get 'top_products_sales_chart'
      get 'bottom_products_sales_chart'
    end
  end
  resources :products, only: [:index, :show] do
    member do
      get 'units_chart'
      get 'ammount_chart'
      get 'utilities_chart'
      get 'price_chart'
    end
  end

  devise_for :users

end
