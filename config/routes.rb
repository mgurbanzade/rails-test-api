Rails.application.routes.draw do
  resources :posts, only: :create do
    member do
      post :rate
    end
  end
end
