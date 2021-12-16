Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        post :sign_in, to: 'sessions#create'
        resources :posts
        resources :hotels
      end
    end   
  end
end
