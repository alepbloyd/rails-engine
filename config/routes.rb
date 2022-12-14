Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants#find"
      get "/items/find_all", to: "items#find_all"
      get "/items/find", to: "items#find"

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end

      resources :items, only: [:index, :show, :create, :destroy, :update] do
        resources :merchant, only: [:index], controller: 'items_merchant'
      end
    end
  end
end
