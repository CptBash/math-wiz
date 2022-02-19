Rails.application.routes.draw do
  get 'health_check/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # root "calculations#index"

  namespace :api do
    namespace :v1 do
      resources :calculations, only: [:index, :show, :create, :destroy]
    end
  end
end
