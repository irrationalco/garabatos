Rails.application.routes.draw do
  root 'pages#dashboard'

  get 'top_products_chart', to: 'pages#top_products_chart'
  get 'bottom_products_chart', to: 'pages#bottom_products_chart'
  get 'best_products_chart', to: 'pages#best_products_chart'
  get 'worst_products_chart', to: 'pages#worst_products_chart'

  get 'units_ammount_chart', to: 'units#ammount_chart'

  resources :units, only: [:index, :show] do
    member do
      get 'top_products_chart'
      get 'bottom_products_chart'
      get 'best_products_chart'
      get 'worst_products_chart'
    end
  end
  resources :products, only: [:index, :show] do
    member do
      get 'units_chart'
      get 'ammount_chart'
      get 'utilities_chart'
      get 'price_chart'
      get 'info_chart'
    end
  end

  devise_for :users

end
