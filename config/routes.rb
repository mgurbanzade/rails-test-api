Rails.application.routes.draw do
  resources :posts, only: :create do
    post :rate, on: :member
    get :most_rated, on: :collection
  end

  resources :locations, only: :index
end
