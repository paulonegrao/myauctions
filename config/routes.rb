Rails.application.routes.draw do
  resources :users, only: [:new, :create]


  resources :auctions, only: [:index, :new, :create, :show] do
    resources :bids, only: [:create]
  end


  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  #resources :bids, only: [:index]

  root "auctions#index"

end
